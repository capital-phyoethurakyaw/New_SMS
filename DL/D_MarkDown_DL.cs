﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entity;
using System.IO;

using System.Data.SqlClient;

namespace DL
{
    public class D_MarkDown_DL : Base_DL
    {
        public DataTable D_MarkDown_SelectAll(D_MarkDown_Entity dme)
        {
            string sp = "D_MarkDown_SelectAll";

            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@VendorCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.VendorCD } },
                { "@StoreCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.StoreCD } },
                { "@StaffCD", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.StaffCD } },
                { "@ChkNotAccount", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.ChkNotAccount } },
                { "@ChkAccounted", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.ChkAccounted } },
                { "@CostingDateFrom", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.CostingDateFrom } },
                { "@CostingDateTo", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.CostingDateTo } },
                { "@PurchaseDateFrom", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.PurchaseDateFrom } },
                { "@PurchaseDateTo", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.PurchaseDateTo } },
            };

            return SelectData(dic, sp);
        }

        public DataTable D_MarkDown_SelectData(D_MarkDown_Entity dme)
        {
            string sp = "D_MarkDown_SelectData";

            Dictionary<string, ValuePair> dic = new Dictionary<string, ValuePair>
            {
                { "@MarkDownNO", new ValuePair { value1 = SqlDbType.VarChar, value2 = dme.MarkDownNO } },
            };

            return SelectData(dic, sp);
        }

        public bool PRC_MarkDownNyuuryoku(D_MarkDown_Entity dme, DataTable dt, short operationMode)
        {
            string sp = "PRC_MarkDownNyuuryoku";

            command = new SqlCommand(sp, GetConnection());
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 0;

            AddParam(command, "@OperateMode", SqlDbType.Int, operationMode.ToString());
            AddParam(command, "@MarkDownNO", SqlDbType.VarChar, dme.MarkDownNO);
            AddParam(command, "@StoreCD", SqlDbType.VarChar, dme.StoreCD);
            AddParam(command, "@SoukoCD", SqlDbType.VarChar, dme.SoukoCD);
            AddParam(command, "@StockReplicaName", SqlDbType.VarChar, dme.StockReplicaName);
            AddParam(command, "@StaffCD", SqlDbType.VarChar, dme.StaffCD);
            AddParam(command, "@VendorCD", SqlDbType.VarChar, dme.VendorCD);
            AddParam(command, "@CostingDate", SqlDbType.VarChar, dme.CostingDate);
            AddParam(command, "@UnitPriceDate", SqlDbType.VarChar, dme.UnitPriceDate);
            AddParam(command, "@ExpectedPurchaseDate", SqlDbType.VarChar, dme.ExpectedPurchaseDate);
            AddParam(command, "@PurchaseDate", SqlDbType.VarChar, dme.PurchaseDate);
            AddParam(command, "@Comment", SqlDbType.VarChar, dme.Comment);
            AddParam(command, "@MDPurchaseNO", SqlDbType.VarChar, dme.MDPurchaseNO);
            AddParam(command, "@PurchaseNO", SqlDbType.VarChar, dme.PurchaseNO);
            AddParam(command, "@PurchaseGaku", SqlDbType.VarChar, dme.PurchaseGaku);

            AddParamForDataTable(command, "@Table", SqlDbType.Structured, dt);
            AddParam(command, "@Operator", SqlDbType.VarChar, dme.InsertOperator);
            AddParam(command, "@PC", SqlDbType.VarChar, dme.PC);

            //OUTパラメータの追加
            string outPutParam = "@OutMarkDownNO";
            command.Parameters.Add(outPutParam, SqlDbType.VarChar, 11);
            command.Parameters[outPutParam].Direction = ParameterDirection.Output;

            UseTransaction = true;

            bool ret = InsertUpdateDeleteData(sp, ref outPutParam);
            if (ret)
                dme.MarkDownNO = outPutParam;

            return ret;
        }
    }
}
