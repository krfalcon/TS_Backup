//
//  EnumHelper.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/3/18.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

typedef NS_ENUM(NSInteger, ViewControllerType) {
    ViewControllerTypeIndex = 0,
    ViewControllerTypeShopList,
    ViewControllerTypeShopInfo,
    ViewControllerTypeEventShopList,
    ViewControllerTypeEventMallList,
    ViewControllerTypeEventInfo,
    ViewControllerTypeEventTheme,
    ViewControllerTypeVideo,
    ViewControllerTypeService,
    ViewControllerTypeItemList,
    ViewControllerTypeItemInfo,
    ViewControllerTypeSale,
    ViewControllerTypeFood,
    ViewControllerTypeFoodReserve,
    ViewControllerTypeMember,
    ViewControllerTypeMemberInfo,
    ViewControllerTypeCollection,
    ViewControllerTypeRegister,
    ViewControllerTypeReset,
    ViewControllerTypeOnline,
    ViewControllerTypeOnlineDetail,
    ViewControllerTypeSigninRuler,
    ViewControllerTypeOffline,
    ViewControllerTypeOfflineDetail,
    ViewControllerTypeMessage,
    ViewControllerTypeMessageInfo,
    ViewControllerTypeLocation,
    ViewControllerTypeReply,
    ViewControllerTypeFeedback,
    ViewControllerTypeBrowser,
    ViewControllerTypeGame,
    ViewControllerTypetappedGameButton,
    ViewControllerTypeSet,
    ViewControllerTypeSetFeedback,
    ViewControllerTypeSetAboutUs,
    ViewControllerTypeExchange,
    ViewControllerTypeExchangeInfo,
    ViewControllerTypeExchangeHistory,
    ViewControllerTypeExchangeUrl,
    ViewControllerTypeWifi,
    ViewControllerTypeMap
    
};

typedef NS_ENUM(NSInteger, WheelViewType) {
    WheelViewTypeShopNil = 0,
    WheelViewTypeShopList,
    WheelViewTypeShopInfo
};

typedef NS_ENUM(NSInteger, SortType) {
    SortTypeDefault = 0,
    SortTypeCHNameAsc,
    SortTypeCHNameDesc,
    SortTypeENNameAsc,
    SortTypeENNameDesc,
    SortTypeLocation,
    SortTypeDescLocation,
    SortTypeEndDateAsc,
    SortTypeEndDateDesc,
    SortTypeUploadDateAsc,
    SortTypeUploadDateDesc,
    SortTypeDiscountAsc,
    SortTypeDiscountDesc,
    SortTypeDiscountRateAsc,
    SortTypeDiscountRateDesc,
    SortTypeOnlinePointAsc,
    SortTypeOnlinePointDesc,
    SortTypeOfflinePointAsc,
    SortTypeOfflinePointDesc
};

typedef NS_ENUM(NSInteger, ShopViewType) {
    ShopViewTypeInfo = 0,
    ShopViewTypeEvent,
    ShopViewTypeItem,
    ShopViewTypeVideo
};

typedef NS_ENUM(NSInteger, CategoryType) {
    CategoryTypeAll = 0,
    CategoryTypeBags,
    CategoryTypeCasual,
    CategoryTypeClothes,
    CategoryTypeFamous,
    CategoryTypeFood,
    CategoryTypeKid,
    CategoryTypeOrnament,
    CategoryTypeShoes,
    CategoryTypeSweater,
    CategoryTypeUnderwear,
    CategoryTypeSports
};