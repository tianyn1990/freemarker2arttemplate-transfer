<#escape x as x?html>
<#compress>
<#--
搜索结果列表
param1:图片链接后面跟的自定义参数
param2:title链接后面跟的自定义参数
param3:评论链接后面更的自定义参数

自定义参数中的{i}，替换goods_index
-->
<#macro searchResultList list=[] param1='' param2='' param3='' param4='' isShowColorSku=false>
	<div class="m-result" id="searchresult">
		<ul class="clearfix" id="result">
    <#-- gtm收集商品数据 -->
    <#local gtmGoods = [] />
    <#list list as goods>
        <#assign pa1 = param1?replace('{i}', goods_index) />
        <#assign pa2 = param2?replace('{i}', goods_index) />
        <#assign pa3 = param3?replace('{i}', goods_index) />
        <#assign pa4 = param4?replace('{i}', goods_index) />
    <#if (goods.type!1) == 1><#-- 商品 -->
      <#assign goodsInfo = (goods.goodsSearchResultInfo!goods)>
      <#local hasTag = goodsInfo.benefitPoint?has_content || goodsInfo.selfProduct!false/>
      <#local gtmGoods = gtmGoods + [{"id":(goodsInfo.goodsId!0)?c,"price":(goodsInfo.actualCurrentPrice!0)?c}] />
      <#-- storeStatus:分仓后的库存状态库存状态：-1未知，0全国缺货，1正常售卖，2区域不可配送，3区域缺货，4预售 -->
      <#local storeStatus = goodsInfo.storeStatus!-1/>
      <li class="goods<#if isShowColorSku> colorsku</#if>">
      <div class="goodswrap<#if hasTag> promotion</#if>">
        <a target="_blank" title="${(goodsInfo.title)!''}" href="/product/${goodsInfo.goodsId}.html" data-param="${pa1}">
          <div class="img">
            <img alt="${(goodsInfo.title)!''}" class="imgtag img-lazyload" src="${cdnBaseUrl}images/blank.gif" data-src="<#if (goodsInfo.imageUrl!'') != ''>${imgThumbnailUrl(goodsInfo.imageUrl!'',262,262,90)}</#if>" >
            <#if storeStatus==0> <#-- 0全国缺货 -->
              <div class="soldout"></div>
            <#elseif goodsInfo.topLeftLabel?has_content>
              <img class="commactivityflag" src="${imgThumbnailUrl(goodsInfo.topLeftLabel!'', 100, 0, 90)}" />
            <#elseif goodsInfo.goodsRanksTopSample?has_content && (goodsInfo.goodsRanksTopSample.appListRanksImageUrl!'') != ''>
              <img class="ranksTap" src="${imgThumbnailUrl((goodsInfo.goodsRanksTopSample.appListRanksImageUrl)!'',150,150,90)}" alt="${goodsInfo.goodsRanksTopSample.listImageName!''}"/>
            <#elseif (goodsInfo.promoteUrl!'') != ''>
              <img class="promote" src="${noProtocol(goodsInfo.promoteUrl!'')}" />
            <#else>
              <div class="activityflag">
                <#if goodsInfo.bestselling?? &&  goodsInfo.bestselling== true>
                <span class="hot">热销</span>
                <#elseif goodsInfo.isNewGoods?? &&  goodsInfo.isNewGoods== true>
                <span class="new">新品</span>
                </#if>
              </div>
            </#if>

            <#-- storeStatus:分仓后的库存状态库存状态：-1未知，0全国缺货，1正常售卖，2区域不可配送，3区域缺货，4预售 -->
            <#-- 优先级：全国缺货0 > 区域缺货3 > 区域不可配送2 > 定时售卖 > 大促预告价/单品包税 > 仅剩几件 -->
            <#assign isAllNoGoods = storeStatus==0/>
            <#-- 显示 区域缺货 -->
            <#assign isDistNoGoods = goodsInfo.fencangDesc?has_content && storeStatus == 3/>
            <#-- 显示 区域不可配送 -->
            <#assign isDistNoDeli = goodsInfo.fencangDesc?has_content && storeStatus == 2/>
            <#-- 显示 定时售卖 -->
            <#assign isTimingSale = goodsInfo.timingSalePromotionInfo?has_content && storeStatus != 0/>
            <#-- 显示 大促预告价/单品包税 -->
            <#assign isForeShow = goodsInfo.foreNoticePriceInfo?has_content &&
                                  (
                                    goodsInfo.foreNoticePriceInfo.startTimeText?has_content &&
                                    goodsInfo.foreNoticePriceInfo.startTimeColor?has_content &&
                                    goodsInfo.foreNoticePriceInfo.detailPromotionInfo?has_content &&
                                    goodsInfo.foreNoticePriceInfo.simplePromotionInfo?has_content &&
                                    goodsInfo.foreNoticePriceInfo.promotionInfoColor?has_content
                                  ) &&
                                  !isDistNoGoods && !isDistNoDeli && !isTimingSale &&
                                  storeStatus != 0/>
            <#-- 显示 仅剩几件 -->
            <#assign isHasOnly = !isForeShow &&
                               goodsInfo.fencangDesc?has_content &&
                               storeStatus != 0 && storeStatus != 2 && storeStatus != 3/>
            <#-- 预付定金 -->
            <#assign isDeposit = goodsInfo.isDeposit!false == true && goodsInfo.depositDetailInfo?has_content/>

            <#if isAllNoGoods> <#-- 0全国缺货，与其他互斥 -->
            <#elseif isDistNoGoods> <#-- 显示 区域缺货 -->
              <span class="storageMsg z-dist">
                <i class="iconfont icon-stockout"></i>
                <span class="msg">${goodsInfo.fencangDesc}</span>
              </span>
            <#elseif isDistNoDeli> <#-- 显示 区域不可配送 -->
              <span class="storageMsg z-deli">
                <i class="iconfont icon-location"></i>
                <span class="msg">${goodsInfo.fencangDesc}</span>
              </span>
            <#elseif isDeposit> <#-- 预付定金 -->
                <span class="storageMsg z-deposit">
                <span class="msg">${goodsInfo.depositDetailInfo!''}</span>
              </span>
            <#elseif isTimingSale> <#-- 显示 定时售卖 -->
              <span class="storageMsg">
                <i class="iconfont"></i>
                <span class="msg">${goodsInfo.timingSalePromotionInfo}</span>
              </span>
            <#elseif isForeShow> <#-- 显示 大促预告价/单品包税 -->
              <div class="forenotice">
                  <div class="forentime" style="background-color: ${goodsInfo.foreNoticePriceInfo.startTimeColor}">
                      ${goodsInfo.foreNoticePriceInfo.startTimeText}
                      <span class="arr" style="border-color: ${goodsInfo.foreNoticePriceInfo.startTimeColor}"></span>
                  </div>
                  <div class="forepromotion" style="background-color: ${goodsInfo.foreNoticePriceInfo.promotionInfoColor}">
                      ${goodsInfo.foreNoticePriceInfo.detailPromotionInfo}
                      <span class="arr2" style="border-color: ${goodsInfo.foreNoticePriceInfo.promotionInfoColor}"></span>
                  </div>
              </div>
            <#elseif isHasOnly> <#-- 显示 仅剩几件 -->
              <span class="storageMsg z-grey">
                <i class="iconfont"></i>
                <span class="msg">${goodsInfo.fencangDesc}</span>
              </span>
            </#if>
          </div>
        </a>
        <#if isShowColorSku>
        <div class="m-skulist">
          <#if goodsInfo.colorSkuList?? && goodsInfo.colorSkuList?size gt 6>
          <span class="arrow arrow-1 arrowdis-1"></span>
          <span class="arrow arrow-2"></span>
          <div class="skuwrap scroll">
            <ul class="clearfix" style="width:${(36*(goodsInfo.colorSkuList?size))?c}px; left:0px;">
          <#else>
          <div class="skuwrap">
            <ul class="clearfix">
          </#if>
          <#if goodsInfo.colorSkuList?? && goodsInfo.colorSkuList?size gt 0>
              <#list goodsInfo.colorSkuList as sku>
              <li class="skutag" proId="${(sku.propertyValue.propertyValueId)!''}" title="${(sku.propertyValue.propertyValue)!''}"><img class="" data-src="<#if (sku.propertyValue.imageUrl!'') != ''>${imgThumbnailUrl((sku.propertyValue.imageUrl)!'',30,30,90)}</#if>" /><#if !sku.hasStorage><span class="mask"></span></#if></li>
              </#list>
          <#else>
              <li class="skutag" proId=""><img class="" data-src="${imgThumbnailUrl((goodsInfo.imageUrl)!'',30,30,90)}" /></li>
          </#if>
            </ul>
          </div>
        </div>
        </#if>
        <div class="desc clearfix">
          <p class="price">
            <#-- 考拉价，配合新人特价标展示 -->
            <#if goodsInfo.kaolaPrice?has_content>
              <span class="cur"><i>¥</i><#if goodsInfo.actualCurrentPrice??>${shortPrice(goodsInfo.actualCurrentPrice)}<#else>${shortPrice(goodsInfo.suggestPrice!'')}</#if></span><#t>
              <span class="newertag">新人价</span><#t>
              <span class="kaolaprice">考拉价¥${shortPrice(goodsInfo.kaolaPrice)}</span><#t>

            <#-- 会员价 -->
            <#elseif goodsInfo.memberCurrentPrice?has_content>
                <span class="cur"><i>¥</i><#if goodsInfo.actualCurrentPrice??>${shortPrice(goodsInfo.actualCurrentPrice)}<#else>${shortPrice(goodsInfo.suggestPrice!'')}</#if></span><#t>
                <span class="memberprice">
                 <#if goodsInfo.memberPriceShowType ==0 >会员价<#else>黑卡价</#if>
                  <i class="rmb">¥</i>${shortPrice(goodsInfo.memberCurrentPrice)}</span><#t>

            <#-- 预付定金 -->
            <#elseif goodsInfo.isDeposit!false && goodsInfo.totalDepositPrice?has_content>
                <span class="cur"><i>¥</i>${goodsInfo.totalDepositPrice}</span>

                <#--  折扣标签  -->
                <#if goodsInfo.discountBenefitStr?has_content>
                    <span class="discounticon">
                        <i class="corner"></i>
                        <span class="discountstr">${goodsInfo.discountBenefitStr}</span>
                    </span>
                </#if>

            <#else>
                <span class="cur"><i>¥</i><#if goodsInfo.actualCurrentPrice??>${shortPrice(goodsInfo.actualCurrentPrice)}<#else>${shortPrice(goodsInfo.suggestPrice!'')}</#if></span><#t>

                <#--  折扣标签  -->
                <#if goodsInfo.discountBenefitStr?has_content>
                    <span class="discounticon">
                        <i class="corner"></i>
                        <span class="discountstr">${goodsInfo.discountBenefitStr}</span>
                    </span>
                </#if>

                <#if goodsInfo.memberCount?? && goodsInfo.memberCount gt 0 && (goodsInfo.isShowDiscountCost!true) == true && goodsInfo.memberPrice?has_content>
                    <b class="unitpriceLabel">|&ensp;单${goodsInfo.memberUnitName!'件'}¥${goodsInfo.memberPrice!''}</b><#t>
                <#else>
                    <span class="marketprice">¥<del>${(goodsInfo.marketPrice)!''}</del></span>
                </#if>
            </#if>
          </p>
          <div class="titlewrap">
            <#if goodsInfo.memberCount?? && goodsInfo.memberCount gt 0>
            <a class="title" title="${goodsInfo.memberCount}${goodsInfo.memberUnitName!'件'}装 | ${goodsInfo.title!''}" href="/product/${goodsInfo.goodsId}.html" data-param="${pa2}" target="_blank">
              <#--  V尝新标签  -->
              <#if goodsInfo.tasteNew?has_content && goodsInfo.tasteNew>
                <img class="tasteicon" src="${imgThumbnailUrl('//haitao.nos.netease.com/63bbb4ab-d9e3-4095-ad52-9f3c0b5c06a2.png', 64, 24, 90)}" alt="">
              </#if>
              <h2><i>${goodsInfo.memberCount}${goodsInfo.memberUnitName!'件'}装</i> | ${goodsInfo.title!''}</h2>
            </a>
            <#else>
            <a class="title" title="${goodsInfo.title!''}" href="/product/${goodsInfo.goodsId}.html" data-param="${pa2}" target="_blank">
              <#--  V尝新标签  -->
              <#if goodsInfo.tasteNew?has_content && goodsInfo.tasteNew>
                <img class="tasteicon" src="${imgThumbnailUrl('//haitao.nos.netease.com/63bbb4ab-d9e3-4095-ad52-9f3c0b5c06a2.png', 64, 24, 90)}" alt="">
              </#if>
              <h2>${goodsInfo.title!''}</h2>
            </a>
            </#if>
          </div>
          <#-- 利益点标签、自营标签 -->
          <#if hasTag>
          <p class="saelsinfo">
            <#if goodsInfo.selfProduct!false>
                <span class="activity z-self">自营</span><#t>
            </#if>
            <#list goodsInfo.benefitPoint as benefit>
                <span class="activity z-benefit">${benefit!''}</span><#t>
            </#list>
          </p>
          </#if>
          <p class="goodsinfo clearfix">
            <a target="_blank" href="/product/${goodsInfo.goodsId}.html" data-param="${pa3}#mainBtmWrap" class="comments"><span class="icon"></span>${(goodsInfo.commentGoodCount?c)!''}</a>
            <span class="proPlace ellipsis">${(goodsInfo.productionPlace)!''}</span>
          </p>
          <p class="selfflag">
            <#if goodsInfo.selfProduct?? && goodsInfo.selfProduct>
            <span>网易考拉自营</span>
            <#else>
            <#if goodsInfo.shopInfo?? && goodsInfo.shopInfo.shopId?? >
            <a href="//mall.kaola.com/${goodsInfo.shopInfo.shopId}" data-param="${pa4}" target="_blank">
              <#if goodsInfo.shopInfo.supplyTagTitle?? && goodsInfo.shopInfo.supplyTagLogo??>
              <img class="shoptaglogo" src="${noProtocol(goodsInfo.shopInfo.supplyTagLogo!'')}" title="${goodsInfo.shopInfo.supplyTagTitle}"/></#if>${goodsInfo.shopInfo.shopName!''}</a>
            <#else>
            <span>考拉商家</span>
            </#if>
            </#if>
          </p>
        </div>
      </div>
      </li>
    <#elseif goods.type == 2><#-- 活动 -->
        <#assign activityInfo = goods.searchActivityDetail>
        <li class="goods <#if isShowColorSku>skuactivity<#else>activity</#if>">
            <div class="goodswrap">
                <div class="img">
                    <a href="${(activityInfo.activityUrl)!''}" target="_blank" data-param="${pa1}">
                        <img alt="${(activityInfo.activityTitle)!''}" class="imgtag img-lazyload" data-src="${noProtocol((activityInfo.activityImageUrl)!'')}">
                        <div class="desc clearfix">
                            <div class="titlewrap" style="background-color: ${(activityInfo.descColor)!''};">
                                <p class="activitytitle">${(activityInfo.activityTitle)!''}</p>
                                <p class="activitydesc">${(activityInfo.desc)!''}</p>
                                <p class="activityentry">
                                    <span>入场疯抢</span>
                                    <b class="entryicon"></b>
                                </p>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </li>
    </#if>
    </#list>
  	</ul>
    <#noescape>
    <script type="text/javascript" id="__dspCache">
      window.__gtmGoods = ${stringify(gtmGoods)!''};
      (function(){
        var d = document.getElementById('__dspCache');
        d.parentNode.removeChild(d);
      })();
    </script>
    </#noescape>
	</div>
</#macro>

<#-- 新增param1 - 品牌点击链接后面自定义参数 埋点等 -->
<#-- 搜索结果品牌筛选节点 -->
<#macro searchBrandList brandList=[] brandtext='brandId' baseurl='' brandId='' param1=''>
	<#if baseurl != ''>
	<div id="brandbox" class="m-classify z-cat3 j-box clearfix">
        <div id="brandboxwrap">
		<div class="name">品牌：</div>
		<div class="hdbrands j-tagwrap">
		<div class="hdbrands2 ctag">
      <div class="brands  brands-cate all ctag">
        <#list brandList as brand>
        	<a title="${brand.brandName}" href="${baseurl?replace('&'+brandtext+'=[^&]*','&'+brandtext+'='+brand.brandId?c,'ir')}${param1}" data-brid="${brand.brandId?c}">${brand.brandName}</a>
        </#list>
      </div>
    </div>
    </div>
    <div class="morewrap">
      <div class="more ctag hide2" data-param="${baseurl}${param1}" data-brandText="${brandtext}">展开<span></span></div>
    </div>
        </div>
	</div>
	</#if>
</#macro>

<#-- 搜索结果顺序筛选节点 -->
<#macro filterBox type=0 isDesc=true isStock=true isSelfProduct=true isTaxFree=false factoryStoreTag=-1 hideFactoryStoreTag=false totalPage=0 pageNo=1 baseurl='' param1='' lowerPrice='' upperPrice= '' iconUrl='' showSelfPro=false>
	<div class="m-filter clearfix">
		<#--<div class="name">排序：</div>-->
		<div class="hdorder clearfix" id="order">
      <dl class="order">
        <dd class="jtag<#if type==0> active</#if>">
          <span>综合</span>
        </dd>
        <dd class="jtag<#if type==2> active</#if>">
          <span>销量<#if type==2><#if isDesc==true><span class="arrow-down"></span><#else><span class="arrow-up"></span></#if></#if></span>
        </dd>
          <dd class="jtag<#if type==6> active active-1</#if>">
              <span>新品</span>
          </dd>
        <dd class="jtag<#if type==1> active</#if>">
          <span>价格<#if type==1><#if isDesc==true><span class="arrow-down"></span><#else><span class="arrow-up"></span></#if></#if></span>
        </dd>
      </dl>
      <div class="m-priceBox">
          <div class="priceInputs">
            <label>
                <input id="priceStart" placeholder="¥" class="ipt jtag" type="text" value="${(lowerPrice?string == '0' || lowerPrice?string == '-1')?string('',lowerPrice)}"/>
            </label> -
            <label >
              <input id="priceEnd" placeholder="¥" class="ipt jtag"   type="text" value="${(upperPrice?string == '1000000' || lowerPrice?string == '-1')?string('',upperPrice)}"/>
            </label>
            <a class="clearbtn jtag" href="javascript:;">清空</a>
            <button class="btnconfirm jtag">确定</button>
          </div>
      </div>
      <div id="addr" class="m-addrbox f-cb"><span class="tit">收货地</span></div>

      <#--<span class="space"></span>-->
      <label class="m-checkbox <#if isSelfProduct==true> m-checked</#if>">
        <#assign selfProductUrl=getUrlByKeyAndValue(baseurl, 'isSelfProduct', (!isSelfProduct)?string)/>
        <#assign selfProductUrl=getUrlByKeyAndValue(selfProductUrl, 'changeContent', 'isSelfProduct')/>
        <a href="${selfProductUrl!''}">
        <span class="box f-vam"><i>&#xe601;</i><em>&#xe60b;</em></span><span>考拉自营</span>
        </a>
      </label>
      <label class="m-checkbox jtag<#if isStock==true> m-checked</#if>">
        <span class="box f-vam"><i>&#xe601;</i><em>&#xe60b;</em></span><span>仅看有货</span>
      </label>
      <label class="m-checkbox jtag<#if isPromote==true> m-checked</#if>">
        <span class="box f-vam"><i>&#xe601;</i><em>&#xe60b;</em></span><#t>
        <#-- 双十二期间 显示活动图标 12.12 00:00:00~12.14 23:59:59-->
        <#if iconUrl == ''>
        <span>促销</span>
        <#else>
        <img class="promoteIcon" src="${noProtocol(iconUrl!'')}" /><#t>
        </#if>
      </label>
        <#--<label class="m-checkbox jtag<#if isTaxFree==true> m-checked</#if>">-->
            <#--<span class="box f-vam"><i>&#xe601;</i><em>&#xe60b;</em></span><span>包税</span>-->
        <#--</label>-->
        <#if !hideFactoryStoreTag>
            <label class="m-checkbox jtag<#if factoryStoreTag==1> m-checked</#if>">
                <span class="box f-vam"><i>&#xe601;</i><em>&#xe60b;</em></span><span>工厂店</span>
            </label>
        </#if>
      <#if totalPage?? && totalPage != 0 && baseurl !=''>
      <div class="simplePage">
        <span class="num"><i>${pageNo}</i>/${totalPage}</span>
        <#if pageNo==1>
        <span class="arrow-left def-left"></span>
        <#else>
        <a href="${linkParams?replace('&pageNo=[^&]*','&pageNo='+(pageNo - 1)?c,'ir')}${param1}" class="arrow-left"></a>
        </#if>
        <#if pageNo==totalPage>
        <span class="arrow-right def-right"></span>
        <#else>
        <a href="${linkParams?replace('&pageNo=[^&]*','&pageNo='+(pageNo + 1)?c,'ir')}${param1}" class="arrow-right"></a>
        </#if>
      </div>
      </#if>

    </div>
  </div>
</#macro>

<#-- 新增param1 - 分类点击链接后面自定义参数 -->
<#-- 搜索结果分类筛选节点 -->
<#-- 参数说明
  clazz 额外样式
  isInCat2 是否是二级分类结果页下的三级分类
 -->
<#macro searchCategoryList categoryList=[] categorytext='brandId' baseurl='' baseparam='' categoryId='' param1='' catid='' isH1=false clazz='' isInCat2=false>
  <#if baseurl != ''>
  <#local tmpurl = baseurl?split('.html') />
  <#local caturl = '' />
  <div id="classify" class="m-classify  z-cat3 j-box clearfix">
    <div class="name">分类：</div>
    <div class="hdbrands  j-tagwrap">
    <div class="hdbrands2 ctag">
      <div class="brands all ctag">
      <#list categoryList as item>
          <#if isInCat2==false>
            <#if catid != ''>
              <#-- 替换 -->
              <#local caturl = baseurl?replace('-'+catid+'.html','-'+item.categoryId?c+'.html','ir') />
            <#else>
              <#-- 新增 -->
              <#local caturl = baseurl?replace('.html','-'+item.categoryId?c+'.html','ir') />
            </#if>
          <#else>
            <#local caturl = baseurl?replace('.html','/'+item.categoryId?c+'.html','ir') />
          </#if>
          <a href="${caturl!}" data-param="${baseparam}${param1}" data-brid="${item.categoryId?c}">${item.categoryName}</a>
      </#list>
      </div>
    </div>
    </div>
    <div class="morewrap">
      <div class="more ctag hide2">展开<span></span></div>
    </div>
  </div>
  </#if>
</#macro>
<#--搜索页面，类目筛选精简版（单选），没有选中状态，因为需求是选中一个就隐藏之
参数说明：
  clazz 额外样式
  baseurl 基本URL
 -->
<#macro searchCategoryListSimple categoryList=[]  baseurl='' baseparam=''   clazz='' param1='' replaceParam='category' >
    <div id="classify" class="m-classify z-cat3 j-box clearfix">
        <div class="name">分类：</div>
        <div class="hdbrands  j-tagwrap">
            <div class="hdbrands2 ctag">
                <div class="brands all ctag">
                  <#list categoryList as item>
                      <#local   cateUrl=baseurl?replace('&'+replaceParam+'=[^&]*','&'+replaceParam+'='+item.categoryId,'ir')/>
                      <a  href="${cateUrl}${param1}"  data-brid="${item.categoryId}">${item.categoryName}<b>&#xe61b;</b></a>
                  </#list>
                </div>
            </div>
        </div>
        <div class="morewrap">
            <div class="more ctag hide2">展开<span></span></div>
        </div>
    </div>
</#macro>

<#macro brandShow brand={} followed=false total=0 isH1=false>
  <div class="m-brand2">
    <img class="detailImg" src="${imgThumbnailUrl(brand.zoneStripImgUrl!'',540,270,90)}" />
    <div class="content">
      <div class="info">
        <img class="logo" src="${noProtocol(brand.logoPic!'')}" />
        <div class="bname">
          <#if isH1>
          <h1 class="title">${brand.name}</h1>
          <#else>
          <p class="title">${brand.name}</p>
          </#if>
          <p class="sold">在售商品<span>${total}</span>个</p>
        </div>
        <#if searchResult.brand.countryCode??>
        <div class="from">
          <img src="${noProtocol((brand.countryCode.flagImage)!'')}" width="40px">
          <span>${(brand.countryCode.brevName)!''}<br>${(brand.countryCode.name)!''}</span>
        </div>
        </#if>
      </div>
      <div class="intro">
        <p class="detailshort f-ellip5">${brand.detailShort}</p>
        <div class="focus">
        <#if followed == true>
          <span class="follow unfo" id="followBtn" data-bid="${brand.brandId}">已关注</span>
        <#else>
          <span class="follow" id="followBtn" data-bid="${brand.brandId}"><b>&#xe631;</b>&nbsp;关注</span>
        </#if>
         <span  class="focusNumber"><span class="fbold" id="focusCount">${searchResult.brand.focusCount!0}</span>人关注该品牌</span>
        </div>
      </div>
    </div>
  </div>
</#macro>

<#macro moreprototype propertyNameList=[] proSearchInfos=[] >
<#list propertyNameList as property>
  <#if property.proValues??&&property.proNameCn??>
            <#local isShowTag=false/>
            <#list proSearchInfos as proinfo>
              <#if ((proinfo.proNameValueId)!'')?split("_")[0] == ((property.proNameId)!'') >
                <#local isShowTag=true/>
              </#if>
            </#list>
          <#if isShowTag==false>
          <div class="m-classify property z-cat3 clearfix">
            <div class="name">${property.proNameCn!''}：</div>
            <div class="hdbrands autoheight ptag j-tagwrap">
              <div class="hdbrands2 ptag">
              <div class="brands all ptag">
                <#list property.proValues as item>
                      <#-- 新增 -->
                    <#assign replacetext = '&proIds='+item.proNameValueId />
                    <#if proIds?length gt 2>
                       <#assign replacetext = replacetext + ',' />
                    </#if>
                    <a href="${linkParams?replace('&proIds=',replacetext,'ir')}&changeContent=0">${item.proValueDesc!''}</a>
                </#list>
              </div>
                </div>
              </div>
              <div class="morewrap">
                <div class="more ptag hide2">展开<span></span></div>
              </div>
          </div>
          </#if>
  </#if>
</#list>
</#macro>
<#--面包屑上面的类目选择控件-->
<#macro categoryTagBox  baseUrlWithCate='' categoryList=[] categoryId='' categoryName='' param='&changeContent=crumbs_3'
pageType='search' replaceParam='category'>
<#if baseUrlWithCate!=''>
        <#if pageType='search'>
        <#local caturl = baseUrlWithCate?replace('&'+replaceParam+'=[^&]*','&'+replaceParam+'=','ir') />
        <#elseif pageType='brand'>
        <#local caturl = baseUrlWithCate?replace('-'+categoryId+'.html','.html','ir') />
        <#else>
        <#local caturl = baseUrlWithCate?replace('/'+categoryId+'.html','.html','ir') />
        </#if>
    <b class="u-gap f-fl">&gt;</b>
     <a href="${(caturl)!''}${param}" class="catCrumbs">${categoryName}</a>
    <#--<span class="cateTag">-->
    <#--<a href="${(baseUrl)!''}">-->
                <#--<span id="delcat3" class="chosen">${categoryName}<b class="down">&#xe61e;</b>-->
                    <#--<i class="up disNone">&#xe624;</i>-->
                <#--</span>-->
    <#--</a>-->
        <#--<#local cateBoxWidth = categoryList?size*100/>-->
        <#--<span class="cateBox" style="width:-->
            <#--<#if cateBoxWidth gt 400 && cateBoxWidth lt 1601>${'400px'}<#elseif cateBoxWidth gt 1601>${'420px'}<#else>${cateBoxWidth}px</#if>;">-->
            <#--<#list categoryList as item>-->
                <#--<#if pageType='search'>-->
                    <#--<#local caturl = baseUrlWithCate?replace('&category=[^&]*','&category='+(item.categoryId?long)?c,-->
                    <#--'ir') />-->
                <#--<#elseif pageType='brand'>-->
                    <#--<#local caturl = baseUrlWithCate?replace('-'+categoryId+'.html','-'+item.categoryId?c+'.html','ir') />-->
                <#--<#else>-->
                    <#--<#local caturl = baseUrlWithCate?replace('/'+categoryId+'.html','/'+item.categoryId?c+'.html','ir') />-->
                <#--</#if>-->
                <#--<a href="${caturl}${param}"  data-brid="${item.categoryId?c}">${item.categoryName}</a>-->
            <#--</#list>-->
        <#--</span>-->
    <#--</span>-->
</#if>
</#macro>

<#macro countryList list=[] param1=''>
  <div id="country" class="m-classify z-cat3 j-box  clearfix">
    <div class="name">国家/地区：</div>
    <div class="hdbrands autoheight j-tagwrap">
      <div class="hdbrands2 ctag">
      <div class="brands all ctag">
        <#list list as item>
              <#-- 新增 -->
            <#assign replacetext = '&country='+item.contryId />
            <a href="${linkParams?replace('&country=',replacetext,'ir')}${param1}">${item.countryName!''}</a>
        </#list>
      </div>
      </div>
    </div>
    <div class="morewrap">
      <div class="more ctag hide2">展开<span></span></div>
    </div>
  </div>
</#macro>

</#compress>
</#escape>
