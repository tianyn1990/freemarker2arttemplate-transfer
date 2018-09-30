<#-- 智能模拟数据记载，请勿注释或删除 -->
<#if !cdnBaseUrl??><#include "/fakeData/search/search.ftl"></#if>
<#include "/core.ftl">
<#include "/common.ftl">
<#include "/function.ftl">
<#include "search_inc.ftl">
<#include "search_filter.ftl">

<#escape x as x?html>
<!DOCTYPE html>
<html>
<head>
<#-- 是否为seo搜索词聚合页 -->
    <#assign isSEO = (source!'')=='hotkey'/>
    <#if isSEO>
        <#assign hotkey = hotkey!'' />
        <#noescape>
            <@meta title="${hotkey}-${hotkey}直邮_进口_正品_推荐-网易考拉"
            keywords="${hotkey}"
            description="${hotkey}-${hotkey}直邮_进口_正品_推荐"/>
        </#noescape>
    <#else>
        <@meta title="搜索-网易考拉"
        keywords="跨境,海淘,进口,母婴用品,美妆个护,美食保健,美妆个护,海淘,商城"
        description="网易考拉-安全、放心的跨境海淘网站，官方认证，正品保证。轻松购遍海外进口母婴，进口美食 ，进口美妆、进口电子数码，更多产品正陆续推出。"/>
    </#if>
    
    
    
    <@html5tags/>
</head>
<body id="index-netease-com" class="<#if (isMarketPriceShow!true)==false>z-nomprice</#if>">
    <@newTopNav/>
    <@docHead/>
    <@topTab />
<div class="bodybox">
    <div class="m-search m-search-1" id="searchbox" >
        <#assign searchCondition = searchCondition!{} />
        <#assign key = (searchCondition.key!'')?js_string />
        <#assign searchType = (searchResult.searchType)!'' />
        <#assign keyshow = (searchCondition.key!'') />
        <#assign type = searchCondition.type!'' />
        <#assign isStock = searchCondition.isStock!true />
        <#assign isTaxFree = searchCondition.isTaxFree!false />
        <#assign isSelfProduct = searchCondition.isSelfProduct!false />
        <#assign isPromote = searchCondition.isPromote!false />
        <#assign factoryStoreTag = searchCondition.factoryStoreTag!-1 />
        <#assign isDesc = searchCondition.isDesc!true />
        <#assign pageNo = searchCondition.pageNo!1 />
        <#assign pageSize = searchCondition.pageSize!60 />
        <#assign lowerPrice = (searchCondition.lowerPrice)!'' />
        <#assign upperPrice = (searchCondition.upperPrice)!'' />
        <#assign timestamp = timestamp!'' />
        <#assign proIds = proIds!'' />
        <#assign needBrandDirect = (searchCondition.needBrandDirect?string)!'true' />

        <#assign keytext = 'key' />
        <#assign brandtext = 'brandId' />
        <#assign typetext = 'type' />

        <#-- brandViewType 1品牌直达 2品牌入口，品牌入口不显示品牌面包屑 -->
        <#assign isBrandEntry = ((searchResult.brandViewType)!-1) == 2/>

        <#-- 提供给搜索组的参数 -->
        
        <#if searchCondition.referFrom??>
            <#assign searchRefer = (searchCondition.referFrom?split(',')[0])!''/>
            <#assign referFrom = (searchCondition.referFrom?split(',')[0])!''/>
            <#assign referPosition = (searchCondition.referFrom?split(',')[1])!''/>
        </#if>
        <#if searchResult?has_content && searchResult.goodsActivityList?has_content>

        <#-- 新的国家url参数 -->
            <#assign country=''/>
            <#if searchResult.naviCountryInfos??>
                <#list searchResult.naviCountryInfos as item>
                    <#if item_index == 0>
                        <#assign country=item.contryId/>
                    <#else>
                        <#assign country= country + ',' + item.contryId/>
                    </#if>
                </#list>
            </#if>

        <#-- 新分类url参数 -->
            <#assign categoryId=''>
            <#assign headCategoryId=''>
            <#if searchResult.naviCategorys??>
                <#if searchResult.naviCategorys?size gt 0><#-- 分类id始终是最后一个id -->
                    <#assign categoryId=searchResult.naviCategorys[searchResult.naviCategorys?size-1].categoryId>
                    <#if searchResult.naviCategorys?size==1><#-- 如果只有一个分类，那么headCategoryId=-1 -->
                        <#assign headCategoryId=-1>
                    <#else><#-- 否则headCategoryId为第一个分类de -->
                        <#assign headCategoryId=searchResult.naviCategorys[0].categoryId>
                    </#if>
                </#if>
            </#if>

            <#assign showPop = true />
            <#if isSelfProduct!=false || isPromote!=false || isStock!=false || (lowerPrice?string)!='-1' || (upperPrice?string)!='-1'
            ||  (country?string)!='' || proIds !='' || (categoryId?string) !='' >
                <#assign showPop = false />
            </#if>
        <#-- POP店铺导入 -->
            <#if showPop && searchResult.shopInfoForView?? &&  !searchResult.brand??>
                <a id="shopbox" href="//mall.kaola.com/${searchResult.shopInfoForView.shopId!''}?zn=banner&zp=1&ri=${key}&rp=search" target="_blank" class="m-shop clearfix" style="background:url(${searchResult.shopInfoForView.pcSearchBanner!''})">
                    <img src="${noProtocol(searchResult.shopInfoForView.shopLogo!'')}" class="logo">
                    <span class="bg"></span>
                    <div class="detail">
                        <p class="title f-toe">
                            <#if searchResult.shopInfoForView.supplyTagTitle?? && searchResult.shopInfoForView.supplyTagLogo??>
                                <img class="shoptaglogo" src="${noProtocol(searchResult.shopInfoForView.supplyTagLogo!'')}"/><#t>
                            </#if>${searchResult.shopInfoForView.shopName!''}
                        </p>
                        <p class="content">${searchResult.shopInfoForView.intro!''}</p>
                        <span class="entry">进入店铺></span>
                    </div>
                </a>
            </#if>

            <div class="resultwrap" id="resultwrap">
                <div class="options" id="filterbox">
                <#-- 品牌列表 -->
                    <#if searchResult.total gte 0>

                        <#assign recQuery = '' />
                        <#assign recQueryUrl = '' />
                    <#-- 优先判断推荐列表 -->
                        <#if (searchResult.recommenResult)?has_content && searchResult.recommenResult.queries?has_content>

                            <#assign recommenInfo = searchResult.recommenResult />
                            <#assign firstquerys = (recommenInfo.queries[0])!'' />
                            <#assign hasMultiQueries = recommenInfo.queries?size gt 1/>

                            <div class="correction">
                                <p>没找到“<span class="keytxt">${keyshow}</span>”相关商品，小考拉为你推荐“<a
                                        href="/search.html?searchType=${searchType?string}&key=${(firstquerys!''?string)?url('utf-8')?url('utf-8')}&spellCheck=false">${firstquerys}</a>”相关商品
                                </p>
                                <#if hasMultiQueries>
                                    <p>你可能还需要：
                                        <#list recommenInfo.queries as query>
                                            <#if query_index gt 0>
                                                “<a href="/search.html?searchType=${searchType?string}&key=${(query!''?string)?url('utf-8')?url('utf-8')}&spellCheck=false">${query}</a>”<#if !!query_has_next>、</#if>
                                            </#if>
                                        </#list>
                                    </p>
                                </#if>
                            </div>
                        <#elseif searchResult.recQuery?? && searchResult.recQuery !=''>
                            <#assign recQuery = searchResult.recQuery />
                            <#assign recQueryUrl = recKey />
                            <#if searchResult.resultType == 0>
                                <div class="correction">
                                    <p>我们为您显示&nbsp;“<span class="keytxt">${keyshow}</span>”&nbsp;相关商品，您是不是要搜&nbsp;“<a
                                            href="/search.html?searchType=${searchType?string}&key=${recQueryUrl}">${recQuery}</a>”</p>
                                </div>
                            <#elseif searchResult.resultType == 1>
                                <div class="correction">
                                    <p>我们为您显示&nbsp;“<span>${recQuery}</span>”&nbsp;相关商品，继续搜索&nbsp;“<a
                                            href="/search.html?searchType=${searchType?string}&key=${orginKey}&spellCheck=false" class="keytxt">${keyshow}</a>”</p>
                                </div>
                            </#if>
                        </#if>

                        <#if firstquerys??><#-- 如果有推荐词就将 key值改为推荐词；否则会搜不到结果 -->
                            <#assign orginKey=firstquerys />
                        </#if>
                        <#assign totalPage=(searchResult.total/pageSize)?ceiling />
                        <#assign linkParams=(domainUrl!'/')+"search.html?key="+(orginKey?string!''?url('utf-8'))+"&pageNo=1&type="+(type?string!'')+"&pageSize=60&isStock="+(isStock?string)
                        +"&isSelfProduct="+(isSelfProduct?string)+"&isDesc="+(isDesc?string)+"&brandId="+((brandId!'')?js_string)+"&proIds="+((proIds!'')?js_string)
                        +"&isSearch=0"+"&isPromote="+(isPromote?string)+"&isTaxFree="+(isTaxFree?string)+"&factoryStoreTag="+(factoryStoreTag?string)+"&backCategory="+categoryId+"&country="+((country?string)!'')
                        +"&headCategoryId="+headCategoryId
                        +"&needBrandDirect="+((needBrandDirect?string)!'true')
                        +"&searchRefer="+((searchRefer?string)!'')
                        +"&referFrom="+((referFrom?string)!'')
                        +"&referPosition="+((referPosition?string)!'')
                        +"&timestamp="+((timestamp?string)!'')
                        +"&lowerPrice="+lowerPrice+"&upperPrice="+upperPrice
                        +"&searchType="+searchType?string/>
                        <#if orginKey?? && orginKey != ''>
                            <#assign allUrl = (domainUrl!'/')+"search.html?key="+(orginKey?string!''?url('utf-8'))+"&pageNo=1&type="+(type?string!'')+"&pageSize=60"
                            +"&needBrandDirect="+((needBrandDirect?string)!'true')+"&changeContent=crumbs_all"+"&searchType="+searchType?string/>
                        <#else> <#-- 如果key不存在直接跳首页 -->
                            <#assign allUrl = '/'/>
                        </#if>

                        <#if (searchResult.resultType != 0 || !searchResult.recQuery?? || searchResult.recQuery =='') && (searchResult.spellCheck!false)!=true>
                        <#-- 按照recQueryUrl来搜索，不需要纠错 -->
                            <#assign linkParams = linkParams+"&recQuery="+recQueryUrl+"&spellCheck=false" />
                        </#if>

                        <div class="resultinfo clearfix">
                        <#--全部结果 面包屑-->
                            <span class="all">
                                <a href="${allUrl}">
                                    <span class="s-color">全部结果</span>
                                </a>
                            </span>
                        <#--三级分类tag-->
                            <#if searchResult.naviCategorys?? && searchResult.naviCategorys?size gt 0>
                                <#assign urlOnlyWithCate = linkParams?replace('&proIds=[^&]*','&proIds=',
                                'ir')?replace('&brandId=[^&]*','&brandId=','ir')?replace('&country=[^&]*','&country=','ir') />
                                <@categoryTagBox_1
                                baseUrlWithCate=urlOnlyWithCate
                                categoryList=searchResult.categoryList
                                pageType='search'
                                replaceParam='backCategory'
                                naviCategorys=searchResult.naviCategorys
                                />
                            </#if>
                        <#--品牌和其他属性面包屑箭头-->
                            <#if (!isBrandEntry && (searchResult.naviBrandInfos?has_content || (searchResult.brand?? && needBrandDirect=='true'))) || (searchResult.naviCountryInfos??&&(searchResult.naviCountryInfos?size) gt 0) || (searchResult.naviPropertyInfos??&&(searchResult.naviPropertyInfos?size) gt 0)>
                                <b class="u-gap f-fl">&gt;</b>
                            </#if>

                            <div class="crumbs-attr-area">

                            <#--品牌信息初始化-->
                                <#if !isBrandEntry && (searchResult.naviBrandInfos?has_content || (searchResult.brand?? && needBrandDirect=='true'))>
                                    <#if searchResult.naviBrandInfos?has_content>
                                        <#list searchResult.naviBrandInfos as brand><#-- 拼接多country的值 -->
                                            <#if brand_index == 0>
                                                <#assign brandstext = brand.brandName!''>
                                            <#else>
                                                <#assign brandstext = brandstext + '、' + brand.brandName!''>
                                            </#if>
                                        </#list>
                                    <#elseif searchResult.brand??>
                                        <#assign brandstext = searchResult.brand.name!''>
                                    </#if>
                                    <span class="chosen J-crumbs-delete" data-type="brand" title="${brandstext}"><span class="value" >品牌:${brandstext}<b>&#xe61b;</b></span></span>
                                </#if>

                            <#-- 国家属性 -->
                                <#if searchResult.naviCountryInfos??&&(searchResult.naviCountryInfos?size) gt 0>
                                    <#list searchResult.naviCountryInfos as country><#-- 拼接多country的值 -->
                                        <#if country_index == 0>
                                            <#assign countryValue = country.countryName!''>
                                        <#else>
                                            <#assign countryValue = countryValue + '、' + country.countryName!''>
                                        </#if>
                                    </#list>
                                    <a class="chosen J-crumbs-delete" data-type="country" href="javascript:;" title="${countryValue}">
                                        <span class="value">国家/地区:${countryValue}</span><b>&#xe61b;</b></span>
                                    </a>
                                </#if>

                            <#-- 其他属性tag -->
                                <#if searchResult.naviPropertyInfos??&&(searchResult.naviPropertyInfos?size) gt 0>
                                    <#list searchResult.naviPropertyInfos as proinfo>
                                        <#list proinfo.proValues as value><#-- 拼接多provalue的值 -->
                                            <#if value_index == 0>
                                                <#assign proValue = value.proValueDesc!''>
                                            <#else>
                                                <#assign proValue = proValue + '、' + value.proValueDesc!''>
                                            </#if>
                                        </#list>
                                        <#if proinfo.proNameId?? && proinfo.proNameCn??>
                                            <a class="chosen J-crumbs-delete" data-type="prop" data-url="${linkParams?replace('[,]?'+proinfo.proNameId+'[_\\d+]*','','ir')?replace('proIds=,','proIds=')}" title="${proValue}" href="javascript:;">
                                                <span class="value">${proinfo.proNameCn}:${proValue}</span>
                                                <b>&#xe61b;</b>
                                            </a>
                                        </#if>
                                    </#list>
                                </#if>
                            </div>
                            <b class="u-gap f-fl">&gt;</b>

                            <label class="detail-search">
                                <input type="text" id="crumbsSearchInput" placeholder="在当前条件下搜索"><b id="crumbsSearchInputIcon" class="w-icon w-icon-26"></b></label>

                            <span class="gnum">商品共<i>${searchResult.total}</i>个</span>
                        </div>
                    </#if>

                    <#if searchResult.brand??>
                        <div class="m-brand">
                            <a target="_blank" href="/brand/${searchResult.brand.brandId}.html">
                                <img class="img-lazyload" data-src="${noProtocol(searchResult.brand.logoPic!'')}"/>
                            </a>

                            <div class="info">
                                <p class="title">
                                    <a target="_blank" href="/brand/${searchResult.brand.brandId}.html">
                                        <span class="brandname">${searchResult.brand.name}</span>
                                    </a>
                                    <#if searchResult.followedBrand!false == true || (searchResult.brand.followedBrand)!false == true>
                                        <span class="follow unfo" id="followBtn"
                                              data-bid="${searchResult.brand.brandId}">已关注</span>
                                    <#else>
                                        <span class="follow" id="followBtn" data-bid="${searchResult.brand.brandId}"><b>
                                            &#xe631;</b>&nbsp;关注</span>
                                    </#if>
                                    <span class="focusNumber"><span class="fbold" id="focusCount">${searchResult.brand
                                    .focusCount!0}</span>人关注该品牌</span>
                                </p>

                                <div class="detail" id="brandtext"><p>${searchResult.brand.detailShort}</p><span
                                        class="dotshow">...</span></div>
                            </div>
                        </div>
                    </#if>
                    <div class="opertaion">
                    <#-- 品牌列表,如果选中品牌则不显示品牌列表 -->
                         <#if !searchResult.brand?? || isBrandEntry>
                        <#if searchResult.brandNameList?? && searchResult.brandNameList?size gt 1>
                            <@searchBrandList_1 brandList=searchResult.brandNameList brandtext=brandtext baseurl=linkParams brandId=brandId param1='&changeContent=brandId' naviBrandInfos=searchResult.naviBrandInfos/>
                        </#if>
                    </#if>
                        <#-- 国家筛选 -->
                        <#if country == ''>
                        <#if searchResult.countryInfoList??&& searchResult.countryInfoList?size gt 1>
                            <@countryList_1 list=searchResult.countryInfoList param1='&changeContent=country'/>
                        </#if>
                    </#if>
                        <#-- 如果选中类目则不显示类目列表 -->
                           <#if searchResult.categoryFilterInfos??>
                        <#if searchResult.categoryFilterInfos??&& searchResult.categoryFilterInfos?size gt 0>
                            <@searchCategoryListSimple_1 categoryList=searchResult.categoryFilterInfos
                            baseurl=linkParams param1='&changeContent=c'
                            naviCategorys=searchResult.naviCategorys
                            replaceParam='backCategory' />
                        </#if>
                    </#if>
                        <#-- 商品其他属性 -->
                        <#if searchResult.propertyNameList?? && searchResult.propertyNameList?size gt 1>
                        <@moreprototype_1 serverPropertyNameList=searchResult.propertyNameList
                        naviPropertyInfos=searchResult.naviPropertyInfos />
                    </#if>
                    </div>

                    <div class="opertaion">
                    <#-- 其他删选条件 -->
				<@filterBox type=type isDesc=isDesc isStock=isStock isTaxFree=isTaxFree factoryStoreTag=factoryStoreTag isSelfProduct=isSelfProduct totalPage=totalPage pageNo=pageNo baseurl=linkParams lowerPrice=lowerPrice upperPrice= upperPrice param1='&changeContent=pageNo' iconUrl=searchResult.goodsFilterImageUrl />
                    </div>
                </div>

            <#-- 结果页面 -->
                <#if searchResult.goodsActivityList?? && searchResult.goodsActivityList?size gt 0>
                    <#assign srId = (searchResult.srId)!'' />
                    <@searchResultList list=searchResult.goodsActivityList param1=('referPage=searchPage&referId='+key?url('utf-8')+'&from=page'+searchResult.pageNo+'&position={i}&istext=0&srId='+srId+'&zn=result&zp=page' + searchResult.pageNo + '-{i}&ri=' + key?url('utf-8') + '&rp=search') param2=('referPage=searchPage&referId='+key?url('utf-8')+'&from=page'+searchResult.pageNo+'&position={i}&istext=1&srId='+srId+'&zn=result&zp=page' + searchResult.pageNo + '-{i}&ri=' + key?url('utf-8') + '&rp=search') param3='referPage=searchPage&referId='+key?url('utf-8')+'&from=page'+searchResult.pageNo+'&position={i}&istext=2&srId='+srId+'&zn=result&zp=page' + searchResult.pageNo + '-{i}&ri=' + key?url('utf-8') + '&rp=search' isShowColorSku=(searchResult.isColorSkuShow()) param4='zn=result&zp=page'+searchResult.pageNo+'-{i}&ri='+key?url('utf-8')+'&rp=search' />
                <#else><#-- 筛选无结果 -->
                    <#if searchResult?? && searchResult.recommenResult?? && searchResult.recommenResult.needRecommend>
                    <#else>
                        <div class="m-empty">
                            <div class="content">
                                <p class="firstline">抱歉，没有找到符合条件的商品</p>
                                <br>

                                <p>建议您：</p>

                                <p>1、适当减少筛选条件，可以获得更多结果</p>

                                <p>2、尝试其他关键词</p>
                            </div>
                            <span class="errorimg"></span>
                        </div>
                    </#if>
                </#if>
                <#assign urlTmpl = linkParams?replace('&pageNo=1','&pageNo={p}')?replace('&pageSize=60','&pageSize='+(pageSize?string!'60')) + '&changeContent=pageNo#topTab' />
                <#if totalPage?? && totalPage gt 1>
                    <@splitPages maxRecordNum=searchResult.total totalPage=totalPage currentPage=pageNo nearPageNum=3 urlTmpl=urlTmpl wrapCss="splitPages" nojump=true />
                </#if>

            </div>
        <#else><#-- 搜索无结果 -->
            <#if searchResult?? && searchResult.redirectType?? && searchResult.redirectType==1> <#--如果是需要重定向的搜索内容 -->
                <div class="m-empty m-empty-3">
                    <div class="content">
                        <p class="firstline">
                            <span class="ellipsis keytext" title="${keyshow}">“${keyshow}”&nbsp;</span>相关商品，考拉海外分站热卖中
                        </p>
                        <p>
                            <a id="J_clearCountDown" target="_blank" href="${searchResult.redirectUrl!'http://www.kaola.com.hk'}" class="btn">立即去看></a>
                        </p>
                    </div>
                    <span class="errorimg2"></span>
                </div>
            <#elseif searchResult?? && searchResult.recommenResult?? && searchResult.recommenResult.needRecommend>
            <#else>
                <div class="m-empty m-empty-2">
                    <div class="content">
                        <p class="firstline">抱歉，没有找到与<span class="ellipsis keytext" title="${keyshow}">“${keyshow}”</span>相关的商品
                        </p>
                        <br>

                        <p>建议您：</p>

                        <p>1、看看输入的文字是否有误</p>

                        <p>2、拆分要搜索的关键词，分成几个词语再次搜索</p>
                    </div>
                    <span class="errorimg"></span>
                </div>
            </#if>
        </#if>
        <#if (searchResult.recommenResult)?has_content && searchResult.recommenResult.needRecommend && searchResult.recommenResult.goodsList?has_content>
            <div class="m-recommend" id="recommendWrap">
                <#if searchResult.goodsActivityList?has_content>
                    <div class="tip fontype">小考拉为你推荐以下商品</div>
                <#else>
                    <div class="correction">
                        <p>没找到&nbsp;“<span class="keytxt">${keyshow}</span>”&nbsp;相关商品，小考拉为你推荐以下商品</p>
                    </div>
                </#if>
                <#assign srId = (searchResult.srId)!'' />
                <@searchResultList list=searchResult.recommenResult.goodsList param1=('referPage=searchPage&referId='+key?url('utf-8')+'&from=page'+searchResult.pageNo+'&position={i}&istext=0&srId='+srId+'&zn=result&zp=page' + searchResult.pageNo + '-{i}&ri=' + key + '&rp=search') param2=('referPage=searchPage&referId='+key?url('utf-8')+'&from=page'+searchResult.pageNo+'&position={i}&istext=1&srId='+srId+'&zn=result&zp=page' + searchResult.pageNo + '-{i}&ri=' + key + '&rp=search') param3='referPage=searchPage&referId='+key?url('utf-8')+'&from=page'+searchResult.pageNo+'&position={i}&istext=2&srId='+srId+'&zn=result&zp=page' + searchResult.pageNo + '-{i}&ri=' + key + '&rp=search' param4='zn=result&zp=page'+searchResult.pageNo+'-{i}&ri='+key+'&rp=search' />
            </div>
        </#if>
    </div>
</div>
<div id="guess" class="newRecomWrap search-recom"></div>
<div id="recomGoodsWrap" class="newRecomWrap search-recom"></div>
<div id="recent" class="newRecomWrap search-recom clearfix recentWrap"></div>

    <#if isSEO && relatedKeyList?? && relatedKeyList?size gt 0>
    <#--大家都感兴趣的：relatedKeyList-->
    <div class="newRecomWrap search-recom clearfix relatedKeyList">
        <h4 class="newRecomTitle clearFix">大家都感兴趣的</h4>

        <div class="m-reclst clearFix">
            <#list relatedKeyList as kw>
                <a class="relative" target="_blank" href="/hotkey/${kw.id}.html"><h3>${kw.keyword}</h3></a><#t>
            </#list>
        </div>
    </div>
    </#if>

    <@rightBarNew />
    <@docFoot/>
    <@ga/>
<!-- @NOPARSE -->
    <#noescape>
    <script type="text/javascript">
        var tempLink = "${(linkParams!'')?js_string}";
        var pageType = 0, searchTypePage=true;
            <#if logdesc??>
            if (window.console) {
                try {
                    console.log('${logdesc?js_string}')
                } catch (e) {
                }
            }
            </#if>
        var brandList=[];
            <#if searchResult?? && searchResult.brandNameList??>
            brandList=${stringify(searchResult.brandNameList)};
            </#if>

            <#if searchResult?? && searchResult.redirectType??>
            var redirectType = '${(searchResult.redirectType!"")?js_string}';
            </#if>
            <#if searchResult?? && searchResult.redirectUrl??>
            var redirectUrl = '${(searchResult.redirectUrl!"http://www.kaola.com.hk")?js_string}';
            </#if>

      var __kaolaGoodsActivityList = ${stringify((searchResult.goodsActivityList)![])};

    </script>
    </#noescape>

<!-- /@NOPARSE -->

<!-- @DEFINE -->

<#-- @jsEntry: search/searchentry.js -->

</body>
</html>
</#escape>
