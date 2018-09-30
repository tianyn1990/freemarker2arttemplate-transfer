const path = require('path');
const { trans } = require('../src/index');

const source = path.resolve(__dirname, './freemarker');
const target = path.resolve(__dirname, './art-template');

trans(source, target);
