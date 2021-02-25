package com.lin.mapper;

import com.lin.entity.Goods;

public interface GoodsMapper {
    int updateGoods(Goods goods);

    Goods selectGoods(Integer id);
}
