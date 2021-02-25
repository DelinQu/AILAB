package com.lin.service.impl;

import com.lin.mapper.GoodsMapper;
import com.lin.mapper.SaleMapper;
import com.lin.entity.Goods;
import com.lin.entity.Sale;
import com.lin.excep.NotEnoughException;
import com.lin.service.BuyGoodsService;

public class BuyGoodsServiceImpl implements BuyGoodsService {
    private SaleMapper saleDao;
    private GoodsMapper goodsDao;
    @Override
    public void buy(Integer goodsId, Integer nums) {
        System.out.println("buy Start here----------------");
        Sale sale  = new Sale();
        sale.setGid(goodsId);
        sale.setNums(nums);

        // 向数据库中插入sale
        saleDao.insertSale(sale);

        //update货物发生异常
        Goods goods  = goodsDao.selectGoods(goodsId);
        if( goods == null){
            //商品不存在
            throw  new  NullPointerException("ID："+goodsId+",商品不存在");
        } else if( goods.getAmount() < nums){
            //商品库存不足
            throw new NotEnoughException("ID："+goodsId+",商品库存不足");
        }

        //update货物
        Goods buyGoods = new Goods();
        buyGoods.setId( goodsId);
        buyGoods.setAmount(nums);
        goodsDao.updateGoods(buyGoods);
        System.out.println("buy finish here---------------");
    }
    public void setSaleDao(SaleMapper saleDao) {
        this.saleDao = saleDao;
    }
    public void setGoodsDao(GoodsMapper goodsDao) {
        this.goodsDao = goodsDao;
    }
}
