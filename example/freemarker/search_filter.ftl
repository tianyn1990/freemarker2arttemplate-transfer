<#escape x as x?html>
<#compress>

<#-- 新增param1 - 品牌点击链接后面自定义参数 埋点等 -->
<#-- 搜索结果品牌筛选节点 -->
<#macro searchBrandList_1 brandList=[] brandtext='brandId' baseurl='' brandId='' param1='' naviBrandInfos=[]>

  <#-- 去重 -->
  <#local size=brandList?size/>
  <#if size gt 20>
    <#local size=20/>
  </#if>
  <#assign newBrandsList=[]/>
  <#if size gt 0>
    <#assign subBrandList=brandList[0..size-1]/>
    <#list subBrandList as brand>
      <#local hasFlag = false/>
        <#list naviBrandInfos as navBrand>
          <#if brand.brandId == navBrand.brandId>
            <#local hasFlag = true/>
          </#if>
        </#list>
      <#if hasFlag == false>
          <#assign newBrandsList = newBrandsList + [brand]>
        </#if>
    </#list>
  </#if>
	<#if baseurl != '' && newBrandsList?size gt 1>
	<div id="brandbox" class="m-classify z-cat3 j-box clearfix" data-id="brandbox">
        <div id="brandboxwrap">
		<div class="name">品牌</div>
		<div class="hdbrands j-tagwrap" data-searchkey="${brandtext}">
		<div class="hdbrands2 ctag">
      <div class="brands  brands-cate all ctag">
        <#list newBrandsList as brand>
        <#if brand.brandName??>
        	<a title="${brand.brandName}" href="${getUrlByKeyAndValue(baseurl, brandtext, brand.brandId)}${param1}" data-brid="${brand.brandId?c}" data-id="${brand.brandId?c}" class="j-multiItem">${brand.brandName}</a>
        </#if>
        </#list>
      </div>
    </div>
    <div class="button-group">
        <span href="javascript;" class="btn save j-saveMultiMode">确定</span>
        <span href="javascript;" class="btn cancel j-cancelMultiMode">取消</span>
    </div>
    </div>

    <div class="morewrap" data-param="${baseurl}${param1}" data-brandText="${brandtext}">
      <div class="more ctag hide2" data-param="${baseurl}${param1}" data-brandText="${brandtext}">展开<span></span></div>
      <span class="item-multiple j-openMultiMode">
          <i class="icon iconfont add icon-miniplus"></i><span>多选</span>
        </span>
    </div>
        </div>
	</div>
	</#if>
</#macro>

<#--搜索页面，类目筛选改版，分为最多3行的形式；
左侧标题：分类/其他分类/父级分类名
右侧列表：取childCates里的分类id和name
逻辑：
1. 最多显示3行
2. 如果只有一项，那么就显示一行，标题显示 ‘分类’
3. 每行数据至少要有2项，否则不显示
4. 如果只有3项，那么就全部平铺
5. categoryId == -1的话，说明是‘其他分类’，平铺展示子类

数据结构请查看
webapp/WEB-INF/ftl/fakeData/search/search.ftl
里的categoryFilterInfos
 -->
<#macro searchCategoryListSimple_1 categoryList=[]  baseurl='' baseparam=''   clazz='' param1='' replaceParam='category' naviCategorys=[] brandId='' pageType=''>
    <#list categoryList as item><#if item_index < 3 && (categoryList?size != 1 || item.childCates?? && item.childCates?size gt 1)> <#-- 最多3条 -->
    <div class="m-classify z-cat3 j-box clearfix">
        <div class="name">
          <i class="icon iconfont icon-tridown"></i>
          <#local cateUrl=getUrlByKeyAndValue(baseurl, replaceParam, item.categoryId)/>
          <#local cateUrl=getUrlByKeyAndValue(cateUrl, 'headCategoryId', -1)/>
          <#-- 品牌页需要替换brand/brandid-xxx(category).html 这里的分类id -->
          <#if brandId??>
              <#local cateUrl=cateUrl?replace('brand/[^.]*','brand/'+brandId + '-' + item.categoryId,'ir')/>
          </#if>
          <#if categoryList?size == 1>分类
          <#elseif item.categoryId == -1>其他分类
          <#else><a  href="${cateUrl}${param1}"  data-brid="${item.categoryId}">${item.categoryName}</a>
          </#if>
        </div>
        <div class="hdbrands j-tagwrap line2height <#if item.categoryId == -1>line1height</#if>" data-searchkey="backCategory">
            <div class="hdbrands2 ctag">
                <div class="brands all ctag">
                  <#if item.childCates??>
                  <#list item.childCates as childItem><#if childItem.categoryName??>
                      <#if categoryList?size == 1 && naviCategorys?size gt 0><#-- 末级分类 -->
                      <#local categoryId=naviCategorys[0].categoryId>  
                      <#else>
                      <#local categoryId=item.categoryId>  
                      </#if>
                      <#local cateUrl=getUrlByKeyAndValue(baseurl, replaceParam, childItem.categoryId)/>
                      <#local cateUrl=getUrlByKeyAndValue(cateUrl, 'headCategoryId', categoryId)/>
                      <#if brandId??><#-- 品牌页需要替换brand/brandid-xxx(category).html 这里的分类id -->
                          <#local cateUrl=cateUrl?replace('brand/[^.]*','brand/'+brandId + '-' + childItem.categoryId,'ir')/>
                      </#if>
                      <a  title="${childItem.categoryName}" href="${cateUrl}${param1}"  data-brid="${childItem.categoryId}">${childItem.categoryName}<b>&#xe61b;</b></a>
                  </#if></#list>
                  </#if>
                </div>
            </div>
          </div>
        <div class="morewrap">
            <div class="more ctag hide2">展开<span></span></div>
        </div>
    </div>
    </#if></#list>
</#macro>

<#-- 属性的筛选项 
数据结构：
propertyNameList webapp/WEB-INF/ftl/fakeData/search/search.ftl 

逻辑：
- 总长度小于3，所有属性平铺展示
- 长度大于3，前2项平铺展示，后面的全部放入其他属性；
- 其他属性中的样式为，父类名平铺，hover父类展示所有子类
-->
<#macro moreprototype_1 serverPropertyNameList=[] naviPropertyInfos=[]>
  <#-- 过滤已经在搜索条件中的属性值-->
    <#assign propertyNameList=[]>
    <#list serverPropertyNameList as property>
      <#local splice=false/>
      <#list naviPropertyInfos as proinfo>
        <#if (proinfo.proNameId!'')==((property.proNameId)!'')>
          <#local splice=true/>
        </#if>
      </#list>
      <#if splice==false>
        <#assign propertyNameList=propertyNameList + [property]>
      </#if>
    </#list>
    <#if proIds?length gt 0>
    <#local proIds=proIds+','/>
    </#if>
    <#-- 第一，第二项或者总长度只有3的时候, 全部平铺显示； -->
      <#if propertyNameList?size lte 3>
        <#list propertyNameList as property>
          <#if property.proValues??&&property.proNameCn??>
            <div class="m-classify property z-cat3 clearfix j-box">
              <div class="name">${property.proNameCn!''}</div>
              <div class="hdbrands line2height line1height j-tagwrap" data-searchkey="proIds">
                <div class="hdbrands2 ctag">
                  <div class="brands all ctag">
                    <#list property.proValues as item> <#if item.proValueDesc??>
                        <#assign replacetext='&proIds=' + proIds + item.proNameValueId/>
                        <a title="${item.proValueDesc!''}" class="j-multiItem" data-nameid="${property.proNameId}" data-valueid="${item.proNameValueId}" href="${linkParams?replace('&proIds=[^&]*',replacetext,'ir')}&changeContent=0">${item.proValueDesc!''}</a>
                    </#if> </#list>
                  </div>
                </div>
                <div class="button-group">
                  <span href="javascript;" class="btn save j-saveMultiMode">确定</span>
                  <span href="javascript;" class="btn cancel j-cancelMultiMode">取消</span>
                </div>
              </div>
              <div class="morewrap">
                <div class="more ctag hide2">展开<span></span></div>
                <span class="item-multiple j-openMultiMode">
                    <i class="icon iconfont add icon-miniplus"></i><span>多选</span>
                </span>
              </div>
            </div>
          </#if>
        </#list>
        <#-- 条数大于3，前2条平铺，后两条放入其他属性 -->
          <#else>
            <#list propertyNameList as property>
              <#if property.proValues??&&property.proNameCn??><#if property_index lt 2>
                <div class="m-classify property z-cat3 clearfix j-box">
                  <div class="name">${property.proNameCn!''}</div>
                  <div class="hdbrands line2height line1height j-tagwrap" data-searchkey="proIds">
                    <div class="hdbrands2 ctag">
                      <div class="brands all ctag">
                        <#list property.proValues as item> <#if item.proValueDesc??>
                            <#assign replacetext='&proIds=' + proIds +item.proNameValueId />
                            <a class="j-multiItem" data-nameid="${property.proNameId}" data-valueid="${item.proNameValueId}" href="${linkParams?replace('&proIds=[^&]*',replacetext,'ir')}&changeContent=0" title="${item.proValueDesc!''}">${item.proValueDesc!''}</a>
                        </#if> </#list>
                      </div>
                    </div>
                    <div class="button-group">
                      <span href="javascript;" class="btn save j-saveMultiMode">确定</span>
                      <span href="javascript;" class="btn cancel j-cancelMultiMode">取消</span>
                    </div>
                  </div>
                  <div class="morewrap">
                    <div class="more ctag hide2">展开<span></span></div>
                    <span class="item-multiple j-openMultiMode">
                        <i class="icon iconfont add icon-miniplus"></i><span>多选</span>
                    </span>
                  </div>
                </div>
              </#if></#if>
            </#list>
            <div class="m-classify property z-cat3 clearfix j-box">
              <div class="name">其他属性</div>
              <div class="hdbrands autoheight">
                <div class="hdbrands2 ctag">
                  <div class="attr-items all ctag">
                    <#list propertyNameList as property>
                      <#if property_index gte 2> <#-- 从第三条开始显示 -->
                        <a href="javascript:;" class="dditem j-attrItem">${property.proNameCn!''}<i class="icon iconfont down icon-paixujiantouxia"></i><i class="icon iconfont up icon-paixujiantoushang"></i></a>
                      </#if>
                    </#list>
                  </div>
                </div>
              </div>
              <#list propertyNameList as property>
                <#if property_index gte 2> <#-- 从第三条开始显示 -->
                  <div class="dropdownlist-content j-tagwrap" data-searchkey="proIds">
                    <div class="clearfix list">
                      <#list property.proValues as item><#if item.proValueDesc??>
                        <#assign replacetext='&proIds=' + proIds + item.proNameValueId />
                        <a data-nameid="${property.proNameId}" data-valueid="${item.proNameValueId}" href="${linkParams?replace('&proIds=[^&]*',replacetext,'ir')}&changeContent=0" class="list-item j-multiItem" title="${item.proValueDesc!''}">${item.proValueDesc!''}</a>
                      </#if></#list>
                      <span class="item-multiple j-openMultiMode">
                          <i class="icon iconfont add icon-miniplus"></i><span>多选</span>
                      </span>
                    </div>
                    <div class="button-group">
                      <span href="javascript;" class="btn save j-saveMultiMode">确定</span>
                      <span href="javascript;" class="btn cancel j-cancelMultiMode">取消</span>
                    </div>
                  </div>
                </#if>
              </#list>
            </div>

      </#if>
</#macro>

<#--面包屑上面的类目选择控件
  headCategoryId是后端用来拼接面包屑用的
  逻辑：
   - 如果是第一项就传-1
   - 其他的传第一项的categoryId
-->
<#macro categoryTagBox_1  baseUrlWithCate='' categoryList=[] param='&changeContent=crumbs_c'
pageType='search' replaceParam='category' naviCategorys=[] brandId=''>
<#if baseUrlWithCate!=''>
    <#list naviCategorys as cat>
      <#-- 根据naviCategorys，进行多层分级 -->
      <b class="u-gap f-fl">&gt;</b>
      <#if cat_index == 0><#-- 如果是第一项那么headCategory为-1，后面的都用第一项的categoryId -->
        <#local cateUrl=getUrlByKeyAndValue(baseUrlWithCate, replaceParam, cat.categoryId)/>
        <#local cateUrl=getUrlByKeyAndValue(cateUrl, 'headCategoryId', -1)/>
      <#else>
        <#local cateUrl=getUrlByKeyAndValue(baseUrlWithCate, replaceParam, cat.categoryId)/>
        <#local cateUrl=getUrlByKeyAndValue(cateUrl, 'headCategoryId', naviCategorys[0].categoryId)/>
      </#if>
      <#if brandId??> <#-- 品牌页要替换分类 -->
        <#local cateUrl=cateUrl?replace('brand/[^.]*','brand/'+brandId + '-' + cat.categoryId,'ir')/>
      </#if>
      <a href="${(cateUrl)!''}${param}" class="catCrumbs">${cat.categoryName}</a>
     </#list>
</#if>
</#macro>

<#macro countryList_1 list=[] param1=''>
  <div id="country" class="m-classify z-cat3 j-box  clearfix" data-id="country">
    <div class="name">国家/地区</div>
    <div class="hdbrands line2height line1height j-tagwrap" data-searchkey="country">
      <div class="hdbrands2 ctag">
      <div class="brands all ctag">
        <#list list as item><#if item.countryName??>
              <#-- 新增 -->
            <a class="j-multiItem" data-id="${item.contryId}" href="${getUrlByKeyAndValue(linkParams, 'country', item.contryId)}${param1}" title="${item.countryName!''}">${item.countryName!''}</a>
        </#if></#list>
      </div>
      </div>
      <div class="button-group">
            <span href="javascript;" class="btn save j-saveMultiMode">确定</span>
            <span href="javascript;" class="btn cancel j-cancelMultiMode">取消</span>
        </div>
    </div>
    <div class="morewrap">
      <div class="more ctag hide2">展开<span></span></div>
      <span class="item-multiple j-openMultiMode">
          <i class="icon iconfont add icon-miniplus"></i><span>多选</span>
        </span>
    </div>
  </div>
</#macro>

</#compress>
</#escape>
