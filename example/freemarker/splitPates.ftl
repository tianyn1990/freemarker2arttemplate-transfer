<#------------------------------------------------------------------------------------
	服务器端分页组件(splitPages)，代码逻辑同js组件 ajaxPaging.js
	maxRecordNum=0 //最大记录数量
	currentPage=1	//当前页
	totalPage=1	//最大页数
	urlTmpl="?page={p}" //url链接模版，{p}将被特定的页数替换
	nearPageNum=3	//当前页附近的页数
	wrapCss="splitPages" //包装容器的样式
    -->
    <#macro _linkRangeForSP a z i url><#list a..z as k><#if i==k><span>${k}</span><#else><a href="${url?replace('{p}', k)}">${k}</a></#if></#list></#macro>
    <#macro splitPages maxRecordNum=0 totalPage=1 currentPage=1 nearPageNum=1 urlTmpl="?page={p}" wrapCss="splitPages" nojump=false>
        <#local endMaxLen = nearPageNum * 2 + 2/>
        <#if totalPage gt 1>
        <div class="${wrapCss}"><#--第<strong>${currentPage}</strong>页 共<strong>${totalPage}</strong>页 总<strong>${maxRecordNum}</strong>条-->
            <#if currentPage == 1 ><span class="prevPage">上一页</span><#else><a class="prevPage" href="${urlTmpl?replace('{p}', currentPage-1)}">上一页</a></#if>
            <#if (totalPage <= endMaxLen + 1 )> <#-- 页少，直接输出 -->
                <@_linkRangeForSP a=1 z=totalPage i=currentPage url=urlTmpl/>
            <#elseif (currentPage < nearPageNum + 3)> <#--情况一: 1 2 3 4 5 6 7 8 ... n -->
                <@_linkRangeForSP a=1 z=endMaxLen i=currentPage url=urlTmpl/><em>...</em><@_linkRangeForSP a=totalPage z=totalPage i=currentPage url=urlTmpl/>
            <#elseif (currentPage > totalPage - nearPageNum - 2)> <#-- 情况三: 1 ... 11 12 13 14 15 16 17 18 -->
                <@_linkRangeForSP a=1 z=1 i=currentPage url=urlTmpl/><em>...</em><@_linkRangeForSP a=totalPage-endMaxLen+1 z=totalPage i=currentPage url=urlTmpl/>
            <#else> <#--情况二: 1 ... 3 4 5 * 7 8 9 ... n -->
                <@_linkRangeForSP a=1 z=1 i=currentPage url=urlTmpl/><em>...</em><@_linkRangeForSP a=currentPage-nearPageNum z=currentPage+nearPageNum i=currentPage url=urlTmpl/><em>...</em><@_linkRangeForSP a=totalPage z=totalPage i=currentPage url=urlTmpl/>
            </#if>
            <#if currentPage == totalPage ><span class="nextPage">下一页</span><#else><a class="nextPage" href="${urlTmpl?replace('{p}', currentPage+1)}">下一页</a></#if>
            <#if nojump==false>
            <span class="jumptoTip">到第</span><input id="jumpto" class="jumptoTxt" tmpl="${urlTmpl}" type="text" value="${currentPage}" /><span class="jumptoTip">页</span><a class="jumptoBtn" href="javascript:;">确定</a>
            </#if>
        </div>
        </#if>
    </#macro>