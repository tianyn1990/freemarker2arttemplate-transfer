<#include "/core.ftl">
<#include "/common.ftl">
<#escape x as x?html>
<!DOCTYPE html>
<html>
<head>
	<@meta title="优惠券适用商品"
		keywords="跨境,海淘,进口,母婴用品,美妆个护,美食保健,美妆个护,海淘,商城"
	   description="网易考拉-安全、放心的跨境海淘网站，官方认证，正品保证。轻松购遍海外进口母婴，进口美食 ，进口美妆、进口电子数码，更多产品正陆续推出。"/>
	
	
	
</head>
<body>
<@newTopNav/>
<@docHead/>
<@topTab />
<#if coupon?? && coupon.couponScheme??>
<div>
	<div class="m-coupon">
		<#assign amount = (coupon.couponAmount)!(coupon.couponScheme.couponAmount)!0 />
		<#if amount lt 50>
			<#assign amountType = 1 />
		<#elseif amount lt 500>
			<#assign amountType = 2 />
		<#else>
			<#assign amountType = 3 />
		</#if>
		<#if coupon.couponRule.terminalType??>
		<#switch coupon.couponRule.terminalType>
			<#case 10><#assign terminalText = '网页端专享'/><#break>
			<#case 20><#assign terminalText = '网页端专享'/><#break>
			<#case 30><#assign terminalText = 'APP专享'/><#break>
			<#case 31><#assign terminalText = 'iPhone专享'/><#break>
			<#case 32><#assign terminalText = '安卓专享'/><#break>
			<#case 40><#assign terminalText = '微信小程序专享'/><#break>
		</#switch>
		</#if>
		<#assign couponScheme = coupon.couponScheme>
		<div class="info info${amountType}">
            <#if (coupon.isBlackCardCoupon!false)>
                <div class="blackCardIcon"></div>
            </#if>

			<#--  折扣券：4:无门槛打折 5:满额打折 6：满件打折  -->
			<#if couponScheme.couponType == 4 || couponScheme.couponType == 5 || couponScheme.couponType == 6>
				<#assign discount = coupon.discount!'0'/>
				<#assign discountAry = discount?split(".")/>
				<#assign first = discountAry[0]!''/>
				<#assign second = discountAry[1]!''/>
				<div class="amount">
					<span class="s-fs-34 s-fw-bold">${first}<#if second?has_content><span class="s-fs-30">.${second}</span></#if></span>
					<span class="s-fs-18">折</span>
				</div>
				<div class="condition">
					<#if couponScheme.couponType == 4>
						<div class="text f-vam">无门槛</div>
					<#elseif couponScheme.couponType == 5>
						<div class="text f-vam">满${(couponScheme.threshold)!''}元使用</div>
					<#elseif couponScheme.couponType == 6>
						<div class="text f-vam">满${(couponScheme.numberThreshold)!''}件使用</div>
					</#if>
				</div>

			<#--  类型：每满减  -->
			<#elseif couponScheme.couponType == 3>
				<div class="amount">
					<span class="s-fs-20">¥</span>
					<span class="s-fs-34 s-fw-bold">${amount}</span>
					<span class="s-fs-20">起</span>
				</div>
				<div class="condition">
					<#assign maxReduceAmount = (couponScheme.maxReduceAmount)!0/>
					<div class="text f-vam">每满${(couponScheme.threshold)!''}减${amount}<#if maxReduceAmount?has_content && maxReduceAmount!=0><br>最高减${(couponScheme.maxReduceAmount)!''}</#if></div>
				</div>

			<#--  其他类型  -->
			<#else>
				<div class="amount">
					<span class="s-fs-20">¥</span>
					<span class="s-fs-34 s-fw-bold">${amount}</span>
				</div>
				<div class="condition">
					<div class="text f-vam"><#if couponScheme.couponType == 1>满${(couponScheme.threshold)!''}元可用<#elseif couponScheme.couponType == 2>无金额门槛</#if><#if terminalText??><br>${(terminalText)!''}</#if></div>
				</div>
			</#if>

			<div class="border left border${amountType*2-1}"></div>
			<div class="border right border${amountType*2}"></div>
		</div>
		<div class="detail">
			<div class="text">
				<p class="ellipsis" title="">${(couponScheme.schemeName)!''}</p>
				<p class="ellipsis" title="">
					使用期限：
                    <#--refer判断实用的url suit_goods为从考拉豆优惠卷列表页进入-->
					<#if refer?? && refer == 'suit_goods'>
						<#assign expireTimeType = couponScheme.expireTimeType>
						<#if expireTimeType == 1>
                            		领取后${couponScheme.expireDays}天内有效
						<#elseif expireTimeType == 2>
							${couponScheme.couponActiveTime?string("yyyy.MM.dd")}-${couponScheme.couponExpireTime?string("yyyy.MM.dd")}
						</#if>
					<#else>
						<#if (((coupon.leftDays)!4) <= 3)>
                            		${(coupon.expireTimeStr)!'00.00.00'}到期<span class="red">(仅剩${(coupon.leftDays)!0}天)</span>
						<#else>
							${(coupon.activeTimeStr)!'00.00.00'}至${(coupon.expireTimeStr)!'00.00.00'}
						</#if>
					</#if>
				</p>
				<p class="ellipsis" title="">以下商品可使用此优惠券</p>
			</div>
		</div>
		<a class="back" href="/personal/my_coupon.html"><span>返回我的优惠券</span><span class="iconfont">&#xe61f;</span></a>
	</div>
	<div class="m-search" id="searchbox"></div>
</div>
<@docFoot />
<@ga/>
<script type="text/javascript">
	var couponParam = {
		warehouseIds:'${(coupon.couponRule.warehouseList)!''}',
		brandIds:'${(coupon.couponRule.brandList)!''}',
		categoryIds:'${(coupon.couponRule.categoryList)!''}',
		goodsIds:'',
		// goodsIds:'${(coupon.couponRule.goodsList)!''}',
		supplierIds:'${(coupon.couponRule.supplierList)!''}',
		couponSchemeId:'${(coupon.couponSchemeId)!''}',
		supportVirtualGoods: '${(coupon.couponRule.suitableForVirtual)?string}' == 'true',
        importTypes:'${(coupon.couponRule.importTypeList)!''}',
        ruleId: ${(coupon.couponRule.ruleId)!0?c},
		couponId:'${(coupon.couponId)!''}'
	};
    window.__KaolaIsFactory = ${(isFactory!false)?string};
</script>
<#else>
</#if>

<!-- @DEFINE -->

<#-- @jsEntry: personal/couponAggregation.js -->
</body>
</html>
</#escape>
