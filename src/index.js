'use strict';

const fs = require('fs');
const glob = require('glob');
const path = require('path');
const htmlparser = require('htmlparser2');

const checkArgs = (source, target) => new Promise((resolve, reject) => {
    let count = 0;
    if (!source || !target) {
        resolve('Expected argements is \'source\' and \'target\'');
    }
    const len = 2;
    const getCb = (msg) => (err, stats) => {
        count++;
        if (err) {
            reject(err);
            return;
        }
        if (stats.isFile()) {
            reject(new Error(msg));
            return;
        }
        if (count >= len) {
            resolve();
        }
    };
    fs.stat(source, getCb('Expected source is a directory'));
    fs.stat(target, getCb('Expected target is a directory'));
});

const getFiles = (cwd) => {
    const freemarkerOptions = {
        cwd,
        nodir: true
    };
    return glob.sync('**/*.ftl', freemarkerOptions);
};

const util = {
    // 子节点转换为兄弟节点
    //  - 修改节点布局，重新开始循环
    children2next(node, parent) {
        let {children = []} = node;
        node.children = [];
        children.forEach(child => child.parent = parent);
        if(parent.splice) {
            parent = parent.splice(parent.indexOf(node), 1, node, ...children);
        } else {
            parent.children = parent.children.splice(parent.children.indexOf(node), 1, node, ...children);
        }
    },
    // 节点转换为纯文本
    tag2text(node) {
        node.type = 'text';
        node.data = `<${node.name}`;
        Object.keys(node.attribs).forEach(key => {
            const value = node.attribs[key];
            node.data += key;
            if(value) {
                node.data += `=${value}`;
            }
        });
        node.data += '>';
    },
    parse(node, parent) {
        if(node.name === '#--' && !node.changed) {
            this.children2next(node, parent); // 修改节点布局，重新开始循环
            this.tag2text(node);
            node.changed = true; // 已完成修改
            return true;
        }
    }
};

const convert = (path) => {
    let html = fs.readFileSync(path, 'utf-8');
    let handler=new htmlparser.DomHandler((err, dom) => {
        if(err) {
            throw err;
        }
        // 递归解析
        (function parseLoop(nodes = [], parent = {}) {
            nodes.forEach(node => {
                const reloop = util.parse(node, parent);
                if(reloop) {
                    parseLoop(dom, dom);
                    return;
                }
                parseLoop(node.children, node);
            });
        })(dom, dom);
        let newhtml = htmlparser.DomUtils.getOuterHTML(dom, {xmlMode:true});
        console.log(newhtml);
    });
    let parser = new htmlparser.Parser(handler,
        {
            onopentag: function(name, attribs){
                if(name === "script" && attribs.type === "text/javascript"){
                    console.log("JS! Hooray!");
                }
            },
            ontext: function(text){
                console.log("-->", text);
            },
            onclosetag: function(tagname){
                if(tagname === "script"){
                    console.log("That's it?!");
                }
            }
        }, {
        decodeEntities: true,
        xmlMode: true
    });
    parser.write(html);
    parser.end();

};

const trans = async function (source, target) {
    try {
        await checkArgs(source, target);
        const files = getFiles(source);
        files.map((file) => {
            // todo convert(path.resolve(source, file));

            // todo delete
            const replaceOptions = {
                '(<#--|<!--)': '<%#',
                '-->': '%>',
                '<#escape([^>]+)>\n': '',
                '</#escape>\n': '',
                '<#if([^>]+)>': '{{if$1}}',
                '</#if>': '{{/if}}',
                '<#else>': '{{else}}',
                '<#elseif([^>]+)>': '{{else if$1}}',
                '<#list ([^>]+) as ([^>]+)>': '{{each $1 $2}}',
                '</#list>': '{{/each}}',
                '<#include \"([^>]+)\">': '{{include \'$1\' }}',
                '<%# @DEFINE %>': '<!-- @DEFINE -->',
                '<%# @jsEntry:([^>]+)\s*%>': '<!-- @jsEntry:$1 -->',
                '\\${([^}]+)}': '{{$1}}',
                '<@(.+) ([^>]+)>': '{{include \'$1\', {$2} }}',
                '<#assign([^>]+)/>': '{{set$1}}',
                '<#assign([^>]+)>': '{{set$1}}',
                '<#local([^>]+)/>': '{{set$1}}',
                '<#local([^>]+)>': '{{set$1}}',
                '!\'\'': ' || \'\'',
                '!true': ' || true',
                '!false': ' || false',
                '!{}': ' || {}',
                '!([0-9]+)': ' || $1',
                '!-([0-9]+)': ' || -$1',
                '!\'true\'': ' || \'true\'',
                '!\'false\'': ' || \'false\'',
                '\\?\\?': '',
                ' gt ': ' > ',
                ' gte ': ' >= ',
                ' lt ': ' < ',
                ' lte ': ' <= ',
                '\\?size': '.length',
                '\\??split': '.split',
                '\\?string[^(]': '',
                '\\?js_string': '',
                '</#compress>': '',
                '<#compress>': '',
                '': '',
                '': '',
            };
            // 其它需要处理：
            //  - ?has_content 对数组做处理
            //  - include
            //  - ?ceiling 等同 Math.ceil()
            //  - ?url('utf-8') 等同 encodeURIComponent
            //  - ?string("yyyy.MM.dd") 类型
            const sourcepath = path.resolve(source, file);
            const targetpath = path.resolve(target, file.replace('.ftl', '.html'));
            let html = fs.readFileSync(sourcepath, 'utf-8');
            Object.keys(replaceOptions).forEach(key => {
                html = html.replace(new RegExp(key, 'g'), replaceOptions[key]);
            });
            fs.writeFileSync(targetpath, html, 'utf-8');

        });
    } catch (err) {
        console.log('-------error--------');
        console.error(err);
        console.log('-------error--------');
        throw err;
    };
};

exports.trans = trans;
