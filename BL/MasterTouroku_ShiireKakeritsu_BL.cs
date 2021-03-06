﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entity;
using DL;
using System.Data;

namespace BL
{

    public class MasterTouroku_ShiireKakeritsu_BL : Base_BL
    {
        MasterTouroku_ShiireKakeritsu_DL mskdl;
        public MasterTouroku_ShiireKakeritsu_BL()
        {
            mskdl = new MasterTouroku_ShiireKakeritsu_DL();
        }
        public DataTable M_ShiireKakeritsu_Select(M_OrderRate_Entity moe)
        {
            return mskdl.MasterTouroku_ShiireKakeritsu_Select(moe);
        }
        public DataTable M_OrderRate_Update(M_OrderRate_Entity moe, string Xml, L_Log_Entity log_data)
        {
            return mskdl.M_Shiirekakeritsu(moe, Xml, log_data);
        }
      
    }
}
