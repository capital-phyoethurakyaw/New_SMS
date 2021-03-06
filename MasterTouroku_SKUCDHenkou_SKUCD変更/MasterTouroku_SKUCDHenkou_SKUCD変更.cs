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
using Search;
using CKM_Controls;
using System.Collections;

namespace MasterTouroku_SKUCDHenkou_SKUCD変更
{
    public partial class MasterTouroku_SKUCDHenkou_SKUCD変更 : FrmMainForm
    {
        MasterTouroku_SKUCDHenkou_SKUCD変更_BL mskubl;
        M_ITEM_Entity mie;
        int type = 0;

        private int min=0;
        private int max = 0;

        public MasterTouroku_SKUCDHenkou_SKUCD変更()
        {
            InitializeComponent();
            mskubl = new MasterTouroku_SKUCDHenkou_SKUCD変更_BL();
            mie = new M_ITEM_Entity();
        }

        private void MasterTouroku_SKUCDHenkou_SKUCD変更_Load(object sender, EventArgs e)
        {
            InProgramID = "MasterTouroku_SKUCDHenkou_SKUCD変更";
            SetFunctionLabel(EProMode.MENTE);
            StartProgram();
            Sc_Item.SetFocus(1);
            F4Visible = false;
            F5Visible = false;
            F7Visible = false;
            F8Visible = false;
            F10Visible = false;
        }

        private void SetRequiredField()
        {
            Sc_Item.TxtCode.Require(true);
        }
        protected override void EndSec()
        {
            base.EndSec();
        }

        public override void FunctionProcess(int Index)
        {
            CKM_SearchControl sc = new CKM_SearchControl();
            switch (Index + 1)
            {
                case 2:
                    ChangeMode(EOperationMode.INSERT);
                    break;
                case 3:
                    ChangeMode(EOperationMode.UPDATE);
                    break;
                case 4:  
                case 5:                 
                    break;
                case 6:
                    if (bbl.ShowMessage("Q004") == DialogResult.Yes)
                    {
                        ChangeMode(OperationMode);
                        Sc_Item.SetFocus(1);
                    }
                    break;
                case 11:
                    F11();
                    break;
                case 12:
                    F12();
                    break;
            }
        }

        private void ChangeMode(EOperationMode OperationMode)
        {
            base.OperationMode = OperationMode;
            switch (OperationMode)
            {
                case EOperationMode.INSERT:
                    Clear(PanelHeader);
                    Clear(panelDetail);
                    EnablePanel(PanelHeader);
                    //DisablePanel(panelDetail);
                    EnablePanel(panelDetail);
                    Sc_Item.SearchEnable = true;
                    F9Visible = true;
                    F11Display.Enabled = F11Enable = true;
                    break;
                case EOperationMode.UPDATE:
                case EOperationMode.DELETE:
                case EOperationMode.SHOW:
                    Clear(PanelHeader);
                    Clear(panelDetail);
                    EnablePanel(PanelHeader);
                    DisablePanel(panelDetail);
                    Sc_Item.SearchEnable = true;
                    F9Visible = true;
                    F12Enable = false;
                    F11Display.Enabled = F11Enable = true;
                    break;
            }
            Sc_Item.SetFocus(1);
        }

        private bool ErrorCheck(int index)
        {
            if(index == 11)
            {
                if (RequireCheck(new Control[] { Sc_Item.TxtCode }))
                    return false;

                if(string.IsNullOrWhiteSpace(txtDate1.Text))
                {
                    mskubl.ShowMessage("E102");
                    txtDate1.Focus();
                    return false;
                }

                if (OperationMode == EOperationMode.INSERT)
                {
                    if(type == 1)
                    {
                        mie.ITemCD = Sc_Item.TxtCode.Text;
                        mie.ChangeDate = txtDate1.Text;
                        DataTable dtitem = new DataTable();
                        dtitem = mskubl.M_ITEM_NormalSelect(mie);
                        if (dtitem.Rows.Count > 0)
                        {
                            mskubl.ShowMessage("E132");
                            Sc_Item.SetFocus(1);
                            return false;
                        }

                    }
                    else if(type == 2)
                    {
                        if (string.IsNullOrWhiteSpace(txtRevDate.Text))
                        {
                            mskubl.ShowMessage("E102");
                            txtRevDate.Focus();
                            return false;
                        }

                        mie.ITemCD = Sc_Item.TxtCode.Text;
                        mie.ChangeDate = txtRevDate.Text;
                        DataTable dtitem = new DataTable();
                        dtitem = mskubl.M_ITEM_NormalSelect(mie);
                        if (dtitem.Rows.Count == 0)
                        {
                            mskubl.ShowMessage("E133");
                            Sc_Item.SetFocus(1);
                            return false;
                        }
                    }
                }
                if(OperationMode == EOperationMode.UPDATE)
                {
                    mie.ITemCD = Sc_Item.TxtCode.Text;
                    mie.ChangeDate = txtDate1.Text;
                    DataTable dtitem = new DataTable();
                    dtitem = mskubl.M_ITEM_NormalSelect(mie);
                    if (dtitem.Rows.Count == 0)
                    {
                        mskubl.ShowMessage("E133");
                        Sc_Item.SetFocus(1);
                        return false;
                    }
                }
            }
            else if(index == 12)
            {
                //string[] b = new string[] { };
                //ArrayList myArryList = new ArrayList();
                #region Size
                string[] sizeArray = new string[10];
                int[] sizemissing = new int[10];
                for (int i = 0; i < 10; i++)
                {
                    var sizeNewtxtbox_ = Controls.Find("txtnewsize" + (i + 1).ToString(), true)[0] as CKM_TextBox;
                    var sizeOldtxtbox_ = Controls.Find("txtoldsize" + (i + 1).ToString(), true)[0] as CKM_TextBox;
                    var sizeCheckbox_ = Controls.Find("SizeDelChk" + (i + 1).ToString(), true)[0] as CKM_CheckBox;
                    /// doooooooooo 
                    /// 
                    if(!string.IsNullOrWhiteSpace(sizeOldtxtbox_.Text))
                    {
                        if (string.IsNullOrWhiteSpace(sizeNewtxtbox_.Text))
                        {
                            mskubl.ShowMessage("E102");
                            sizeNewtxtbox_.Focus();
                            return false;
                        }
                    }
                    sizeArray[i] = sizeNewtxtbox_.Text;
                    if(!string.IsNullOrWhiteSpace(sizeNewtxtbox_.Text))
                    {
                        sizemissing[i] = Convert.ToInt32(sizeNewtxtbox_.Text);
                    }

                    if (sizeCheckbox_.Checked)
                    {
                        max = int.Parse(sizeNewtxtbox_.Text);
                    }                   
                }
                if (SelectCheck(sizemissing))
                {
                    mskubl.ShowMessage("E229");
                    txtnewsize10.Focus();
                    return false;
                }

                if (HasDuplicates(sizeArray))
                {
                    mskubl.ShowMessage("E105");
                    txtnewsize10.Focus();
                    return false;
                }

                int misssize = getMissingNo(sizemissing, 10);
                if ((misssize > 0 && misssize < 11) || (misssize < 0))
                {
                    mskubl.ShowMessage("E228");
                    txtnewsize10.Focus();
                    return false;
                }
                #endregion

                #region Color
                string[] colorArray = new string[20];
                int[] colormissing = new int[20];
                for (int i = 0; i < 20; i++)
                {
                    var colorNewtxtbox_ = Controls.Find("txtnewcolor" + (i + 1).ToString(), true)[0] as CKM_TextBox;
                    var colorOldtxtbox_ = Controls.Find("txtoldcolor" + (i + 1).ToString(), true)[0] as CKM_TextBox;
                    var colorCheckbox_ = Controls.Find("ColorDelChk" + (i + 1).ToString(), true)[0] as CKM_CheckBox;
                    
                    if (!string.IsNullOrWhiteSpace(colorOldtxtbox_.Text))
                    {
                        if (string.IsNullOrWhiteSpace(colorNewtxtbox_.Text))
                        {
                            mskubl.ShowMessage("E102");
                            colorNewtxtbox_.Focus();
                            return false;
                        }
                    }
                    colorArray[i] = colorNewtxtbox_.Text;
                    if (!string.IsNullOrWhiteSpace(colorNewtxtbox_.Text))
                    {
                        sizemissing[i] = Convert.ToInt32(colorNewtxtbox_.Text);
                    }

                    if (colorCheckbox_.Checked)
                    {
                        max = int.Parse(colorCheckbox_.Text);
                    }
                }

                if (SelectCheck(sizemissing))
                {
                    mskubl.ShowMessage("E229");
                    txtnewcolor10.Focus();
                    return false;
                }

                if (HasDuplicates(colorArray))
                {
                    mskubl.ShowMessage("E105");
                    txtnewsize10.Focus();
                    return false;
                }

                int misscolor = getMissingNo(sizemissing, 20);
                if ((misscolor > 0 && misscolor < 11) || (misscolor < 0))
                {
                    mskubl.ShowMessage("E228");
                    txtnewsize10.Focus();
                    return false;
                }
                #endregion
            }

            return true;
        }

        private bool SelectCheck(int[] arrayList)
        {
            foreach (int s in arrayList)
            {
                if(max < s)
                {
                    return false;
                }
            }
                return true;
        }

        private bool HasDuplicates(string [] arrayList)
        {
            List<string> vals = new List<string>();
            bool returnValue = false;
            foreach (string s in arrayList)
            {               
                if (!string.IsNullOrWhiteSpace(s))
                {
                    if (vals.Contains(s))
                    {
                        returnValue = true;
                        break;
                    }
                    vals.Add(s);
                }
            }
            return returnValue;
        }

        private int getMissingNo(int[] a, int n)
        {
            int i, total = 1;

            for (i = 2; i <= (n + 1); i++)
            {
                total += i;
                total -= a[i - 2];
            }
            return total;
        }

        private void F11Display_Click(object sender, EventArgs e)
        {
            if(OperationMode == EOperationMode.INSERT)
            {
                type = 1;
            }
            else if(OperationMode == EOperationMode.UPDATE)
            {
                type = 2;
            }
            F11();
        }

        private void F11()
        {
           
            if (ErrorCheck(11))
            {
                mie.ITemCD = Sc_Item.TxtCode.Text;
                mie.ChangeDate = txtDate1.Text;
                DataTable dtitem = new DataTable();
                dtitem = mskubl.M_ITem_SelectForSKUCDHenkou01(mie);
                //foreach(DataRow row in dtitem.Rows)
                //{
                //    string[] OldSize = new string[10];
                //    string[] NewSize = new string[10];
                //    for (int i = 0; i < 10; i++)
                //    {
                //        OldSize[i] = row["OldSize"].ToString();
                //        NewSize[i] = row["NewSize"].ToString();
                //    }
                        
                    

                //}
            }
          
        }

        private void F12()
        {
            if(ErrorCheck(12))
            {

            }
        }

        private void Sc_Item_CodeKeyDownEvent(object sender, KeyEventArgs e)
        {
            if(e.KeyCode == Keys.Enter)
            {
                F11();
            }
        }

        private void txtDate1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                type = 1;
                F11();
            }
        }

        private void txtRevDate_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                type = 2;
                F11();
            }
        }

    }
}
