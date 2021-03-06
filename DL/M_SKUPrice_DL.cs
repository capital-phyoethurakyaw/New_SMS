﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entity;

using System.Data.SqlClient;

namespace DL
{
    public class M_SKUPrice_DL : Base_DL
    {
        public DataTable M_SKUPrice_Select(M_SKUPrice_Entity mse)
        {
            string sp = "M_SKUPrice_Select";

            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@StoreCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.StoreCD } },
                { "@TankaCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.TankaCD } },
                { "@SKUCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.SKUCD } },
                { "@ChangeDate", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.ChangeDate } },
            };
            return SelectData(dic, sp);
        }

        /*
        public DataTable M_Store_SelectAll(M_Store_Entity mbe)
        {
            string sp = "M_Store_SelectAll";

            command = new SqlCommand(sp, GetConnection());
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 0;

            command.Parameters.Add("@DisplayKbn", SqlDbType.TinyInt).Value = mbe.DisplayKbn;
            command.Parameters.Add("@ChangeDate", SqlDbType.VarChar).Value = mbe.ChangeDate;
            command.Parameters.Add("@StoreCDFrom", SqlDbType.VarChar).Value = mbe.StoreCDFrom;
            command.Parameters.Add("@StoreCDTo", SqlDbType.VarChar).Value = mbe.StoreCDTo;
            command.Parameters.Add("@StoreName", SqlDbType.VarChar).Value = mbe.StoreName;
            command.Parameters.Add("@StoreKBN1", SqlDbType.TinyInt).Value = mbe.StoreKBN1;
            command.Parameters.Add("@StoreKBN2", SqlDbType.TinyInt).Value = mbe.StoreKBN2;
            command.Parameters.Add("@StoreKBN3", SqlDbType.TinyInt).Value = mbe.StoreKBN3;

            return SelectData(sp);
        }
        */
        /// <summary>
        /// SKU販売単価マスタ更新処理
        /// MasterTouroku_HanbaiTankaより更新時に使用
        /// </summary>
        /// <param name="mse"></param>
        /// <param name="operationMode"></param>
        /// <param name="operatorNm"></param>
        /// <param name="pc"></param>
        /// <returns></returns>
        public bool M_SKUPrice_Exec(M_SKUPrice_Entity mse, DataTable dt, short operationMode, string operatorNm, string pc )
        {
            string sp = "PRC_MasterTouroku_HanbaiTanka_SKU";
            command = new SqlCommand(sp, GetConnection());
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 0;

            this.UseTransaction = true;

            AddParam(command,"@OperateMode", SqlDbType.TinyInt, operationMode.ToString());
            AddParam(command,"@StoreCD", SqlDbType.VarChar, mse.StoreCD);
            AddParam(command,"@TankaCD", SqlDbType.VarChar, mse.TankaCD);

            AddParam(command,"@GeneralRate", SqlDbType.Decimal, mse.GeneralRate);
            AddParam(command,"@MemberRate", SqlDbType.Decimal, mse.MemberRate);
            AddParam(command,"@ClientRate", SqlDbType.Decimal, mse.ClientRate);
            AddParam(command,"@SaleRate", SqlDbType.Decimal, mse.SaleRate);
            AddParam(command,"@WebRate", SqlDbType.Decimal, mse.WebRate);
            AddParamForDataTable(command,"@Table", SqlDbType.Structured, dt);

            AddParam(command,"@DeleteFlg", SqlDbType.TinyInt, mse.DeleteFlg);
            AddParam(command,"@UsedFlg", SqlDbType.TinyInt, mse.UsedFlg);
            AddParam(command,"@Operator", SqlDbType.VarChar, operatorNm);
            AddParam(command,"@PC", SqlDbType.VarChar, pc);

            string outPutParam = "";
            return InsertUpdateDeleteData(sp, ref outPutParam);
        }
        /// <summary>
        /// SKU販売単価マスタ取得処理
        /// MasterTouroku_HanbaiTankaよりデータ抽出時に使用
        /// </summary>
        public DataTable M_SKUPrice_SelectData(M_SKUPrice_Entity mse, short operationMode)
        {
            string sp = "M_SKUPrice_SelectData";
            
            //command.Parameters.Add("@SyoKBN", SqlDbType.TinyInt).Value = mie.SyoKBN;
            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@OperateMode", new ValuePair { value1 = SqlDbType.TinyInt, value2 = operationMode.ToString() } },
                { "@ItemFrom", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.ItemFrom } },
                { "@ItemTo", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.ItemTo } },
                { "@StoreCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.StoreCD } },
                { "@TankaCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.TankaCD } },
                { "@BrandCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.BrandCD } },
                { "@ITemName", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.ITemName } },
            };

            return SelectData(dic, sp);

        }
        public DataTable M_SKUPrice_SelectTanka(M_SKUPrice_Entity mse)
        {
            string sp = "M_SKUPrice_SelectTanka";

            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@StoreCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.StoreCD } },
                { "@TankaCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.TankaCD } }, //指定しなくてもよい
                { "@AdminNO", new ValuePair { value1 = SqlDbType.Int, value2 = mse.AdminNO } },
                { "@ChangeDate", new ValuePair { value1 = SqlDbType.VarChar, value2 = mse.ChangeDate } },
            };
            return SelectData(dic, sp);
        }
    }

}
