<#-- 智能模拟数据记载，请勿注释或删除 -->
<#if !cdnBaseUrl??><#include "/fakeData/mergeorder.ftl"></#if>
<#include "/core.ftl">
<#include "/common.ftl">
<#import "/function.ftl" as cof>

<#escape x as x?html>
<!DOCTYPE html>
<html>
<head>
    <#if ranksTop?has_content> <#-- 榜单页 -->
        <#assign metaTitle = '榜单页-网易考拉'/>
    <#else>                    <#-- 整单活动，凑单页 -->
        <#assign metaTitle = '凑单页-网易考拉'/>
    </#if>
    <@meta title=metaTitle
    keywords="跨境,海淘,进口,母婴用品,美妆个护,美食保健,美妆个护,海淘,商城"
    description="网易考拉-安全、放心的跨境海淘网站，官方认证，正品保证。轻松购遍海外进口母婴，进口美食 ，进口美妆、进口电子数码，更多产品正陆续推出。"/>
    
    
    
    <@html5tags/>
</head>
<body id="index-netease-com">
    <@newTopNav/>
    <@docHead/>
    <@topTab />

<#assign activityType = activityType!0/>
<#macro actType title='' message=''>
<p id="m-acttype" class="m-acttype">
  <span class="icon f-fl">${title!''}</span>
  <span class="iconr f-fl"></span>
  ${message}
  <#if (activityType == 26) || (activityType == 27)>
  <span id="showgift-box" class="showgift-box"><a class="u-btn_showgift" id="showgift-btn" href="javascript:void(0)">查看赠品<i id="icon-arrow" class="iconfont icon-arrow-down"></i></a><i id="icon-triup" class="iconfont icon-triup hide"></i><span>
  </#if>
</p>
</#macro>

<div class="bodybox">
    <div class="m-search">
        <div class="resultwrap">
            
            <#if ranksTop?has_content>
            <#-- 榜单页 -->
                <#if ranksTop.pcHeaderRanksImageUrl??>
                    <img class="img-lazyload" data-src="${ranksTop.pcHeaderRanksImageUrl}?imageView&thumbnail=1090x0&quality=90" style="max-width:100%;margin-left:7px;"/>
                <#else>
                <@actType title=ranksTop.ranksTopName!'' message="本页商品，均为榜单推荐商品！"/>
                </#if>
            <#else>
            <#-- 整单活动，凑单页 -->
                <#assign tip="，加入购物车结算立享优惠！" />
                <#if activityTitle?? && activityTitle=="换购">
                    <#assign tip="，请先将商品加入购物车，在购物车低价换购其它商品！" />
                </#if>
                <#if activityTitle?? && activityTitle=="满额赠">
                    <#assign tip="，赠品数量有限，赠完即止，加入购物车结算挑选赠品！" />
                </#if>
                <#if activityTitle?? && activityTitle=="满件赠">
                    <#assign tip="，赠品数量有限，赠完即止，加入购物车结算挑选赠品！" />
                </#if>
                                                
                <#if activityTitle?? && activityDetails??>
                <@actType title=activityTitle message=""+(activityDetails!'')+(tip)/>
            </#if>
            </#if>
            <div id="m-list"></div>
        </div>
    </div>
</div>

    <@rightBarNew />
    <@docFoot/>
    <@ga/>
    <#noescape>
    <!-- @NOPARSE -->
    <script type="text/javascript">
        <#-- url模版用于分页跳转 -->
        <#-- mini分页器url -->
        <#--window.urlTmpl="${domainUrl!'/'}activity/goods/${activitySchemeId?string!''}.html?pageNo={p}&pageSize=${page.pageSize?string!''}&priceSort=${param.priceSort!''}&saleNumSort=${param.saleNumSort!''}&maxPrice=${param.maxPrice!''}&minPrice=${param.minPrice!''}";-->
        <#--window.miniUrlTmpl="${domainUrl!'/'}activity/goods/${activitySchemeId?string!''}.html?pageNo=${page.pageNo?string!1}&pageSize=${page.pageSize?string!''}&priceSort=${param.priceSort!''}&saleNumSort=${param.saleNumSort!''}&maxPrice=${param.maxPrice!''}&minPrice=${param.minPrice!''}";-->
        <#if ranksTop?has_content>  
        <#-- 榜单页 -->
        window.__RanksTopId__ = "${((ranksTop.ranksTopId)!0)?c}";
        window.__ShowType__ = "${(ranksTop.showType!'')?js_string}";
        window.__ShowDesc__ = "${(ranksTop.showDesc!'')?js_string}";
        <#else>
        <#-- 整单活动，凑单页 -->
        window.__SchemeId__ = ${(activitySchemeId!0)?c};
        </#if>

        window.__activityType__ = ${activityType!0};
        <#--window.__Page__ = ${cof.stringify(page)};-->
        <#--window.__Params__ = ${cof.stringify(param)};-->
    </script>

    <!-- /@NOPARSE -->
    </#noescape>
<!-- @DEFINE -->

<#-- @jsEntry: order/mergeorder.js -->
</body>
</html>
</#escape>