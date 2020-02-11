﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Base.Client;
using BL;
using Entity;

namespace TempoRegiShiharaiNyuuryoku
{
    public partial class TempoRegiShiharaiNyuuryoku : ShopBaseForm
    {
        TempoRegiShiharaiNyuuryoku_BL trgshbl = new TempoRegiShiharaiNyuuryoku_BL();
        D_DepositHistory_Entity ddpe = new D_DepositHistory_Entity();
        public TempoRegiShiharaiNyuuryoku()
        {
            InitializeComponent();
        }

        private void TempoRejiShiharaiNyuuryoku_Load(object sender, EventArgs e)
        {
            InProgramID = "TempoRegiShiharaiNyuuryoku";

            string data = InOperatorCD;
            StartProgram();
            this.Text = "支払入力";
            SetRequireField();
            BindCombo();
            txtPayment.Focus();
        }

        private void SetRequireField()
        {
            txtPayment.Require(true);
            cboDenominationName.Require(true);
        }

        public void BindCombo()
        {
            cboDenominationName.Bind(string.Empty);
        }

        private void DisplayData()
        {
            txtPayment.Focus();
            string data = InOperatorCD;        
            SetRequireField();
            BindCombo();
        }

        public bool ErrorCheck()
        {
            if(string.IsNullOrWhiteSpace(txtPayment.Text))
            {
                trgshbl.ShowMessage("E102");
                txtPayment.Focus();
                return false;
            }
            if(cboDenominationName.SelectedValue.ToString() == "-1")
            {
                trgshbl.ShowMessage("E102");
                cboDenominationName.Focus();
                return false;
            }

          
            return true;
        }
        protected override void EndSec()
        {
            this.Close();
        }

        public override void FunctionProcess(int index)
        {
            switch (index + 1)
            {
                case 2:
                    Save();                  
                    break;
            }
        }

        private void Save()
        {
            if(ErrorCheck())
            {
                if (trgshbl.ShowMessage("Q101") == DialogResult.Yes)
                {
                    ddpe = GetDepositEntity();
                    if (trgshbl.TempoRegiShiNyuuryoku_InsertUpdate(ddpe))
                    {
                        trgshbl.ShowMessage("I101");
                        txtPayment.Clear();
                        txtPayment.Focus();
                        cboDenominationName.SelectedValue = "-1";
                        txtRemarks.Clear();
                        DisplayData();                       
                    }
                }
            }
        }

        private D_DepositHistory_Entity GetDepositEntity()
        {
            ddpe = new D_DepositHistory_Entity
            {
                StoreCD = InOperatorCD,
                DenominationCD = cboDenominationName.SelectedValue.ToString(),
                DataKBN = "3",
                DepositKBN = "3",
                DepositGaku = txtPayment.Text,
                Remark = txtRemarks.Text,
                ExchangeMoney = "0",
                ExchangeDenomination = string.Empty,
                ExchangeCount = "0",
                AdminNO = string.Empty,
                SalesSU = "0",
                SalesUnitPrice = "0",
                SalesGaku = "0",
                SalesTax = "0",
                TotalGaku = "0",
                Refund = "0",
                IsIssued = "0",
                CancelKBN = "0",
                RecoredKBN = "0",
                Rows = "0",
                SalesTaxRate = "0",
                AccountingDate = DateTime.Today.ToShortDateString(),
                Operator = InOperatorCD,
                ProgramID = InProgramID,
                PC = InPcID,
                ProcessMode = "登 録",
                Key = txtPayment.Text.ToString()
            };
            return ddpe;
        }

        private void TempoRegiShiharaiNyuuryoku_KeyUp(object sender, KeyEventArgs e)
        {
            MoveNextControl(e);
        }
    }
}
