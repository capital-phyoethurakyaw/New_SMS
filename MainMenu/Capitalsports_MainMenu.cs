﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Entity;
using BL;
using CKM_Controls;
using System.Diagnostics;
using DL;
using System.Runtime.InteropServices;
using Microsoft.PointOfService;
using System.Data.SqlClient;
//using Base.Client;
using EPSON_TM30;
using System.Threading;

namespace MainMenu
{
    public partial class Capitalsports_MainMenu : Form
    {
        DataTable menu;
        CKM_Button btnleftcurrent;
        CKM_Button btnrightcurrent;
        Base_DL bdl = new Base_DL();
        M_Staff_Entity mse;
        Menu_BL mbl;
        string Staff_CD = "";
        string btnText = string.Empty;
        private const int SW_SHOWMAXIMIZED = 3;
        [DllImport("user32.dll")]
        static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        CashDrawerOpen cdo = new CashDrawerOpen();

        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("user32", CharSet = CharSet.Ansi, SetLastError = true, ExactSpelling = true)]
        public static extern bool SetForegroundWindow(IntPtr hwnd);
        public Capitalsports_MainMenu(String SCD, M_Staff_Entity mse)
        {
            
            mbl = new Menu_BL();
            Staff_CD = SCD;
            this.mse = mse;
            InitializeComponent();
            lblOperatorName.Text = mse.StaffName;
            SetDesignerFunction();

            lblOperatorName.Text = mse.StaffName;
        }
        private void SetDesignerFunction()
        {
            this.KeyPreview = true;
            Event_Designer(panel_left);
            Event_Designer(panel_right);
            this.Load += Capital_MainMenu_Load;
        }
        private void Capital_MainMenu_Load(object sender, EventArgs e)
        {
          //var f=  GetMessages();
          //  var ds = ASCIIEncoding.ASCII.GetByteCount(f);
            Clear_Text(panel_left);
            Clear_Text(panel_right);
            BindButtonName();
            try
            {
                //var pth = "C:\\SMS\\Appdata";
                //var getmsg = Base_DL.iniEntity.DefaultMessage;
                //Process.Start(pth+ @"\"+ "Display_Service" + ".exe","02_1" + " "+ getmsg + " "+ "-" +" "+"-" );

                if (Base_DL.iniEntity.IsDM_D30Used)
                {
                    cdo.SetDisplay(true, true, Base_DL.iniEntity.DefaultMessage);
                }///Start New Window for display by PTK
            }
            catch (Exception ex)
            {
                MessageBox.Show("Current Error is " +ex.Message + " Skipped if Epson TM-M30 have not been installed.");
            }

        }
        protected void Clear_Text(Panel pnl)
        {
            var c = GetAllControls(pnl);
            int j = 0;
            for (int i = 0; i < c.Count(); i++)
            {
                Control ctrl = c.ElementAt(i) as Control;
                if (ctrl is CKM_Button)
                {
                    j++;
                    ((CKM_Button)ctrl).Text = "";
                    ((CKM_Button)ctrl).Enabled = false;
                    ToolTip ttp = new ToolTip();
                    ttp.SetToolTip(((CKM_Button)ctrl), null);
                    // ((CKM_Button)ctrl).Name = "btnPro" + (c.Count() - (j));
                }
            }


        }
        protected void BindButtonName()
        {
            var dt = menu = mbl.getMenuNo(Staff_CD, Base_DL.iniEntity.StoreType);
            if (dt.Rows.Count > 0)
            {
                var _result = dt.AsEnumerable().GroupBy(x => x.Field<string>("Char1")).Select(g => g.First()).CopyToDataTable();
                //////Changed by PTk bcox of Gtone  HOMESTAYED TIME COVID_19
                var dt1 = dt.AsEnumerable()
                       .GroupBy(r => new { Col1 = r["BusinessID"], Col2 = r["BusinessSEQ"] })
                       .Select(g =>
                       {
                           var row = dt.NewRow();
                        //r => r["PK"]).First()
                        //row["PK"] = g.Min(r => r.Field<int>("PK"));
                        row["char1"] = g.First().Field<string>("char1");
                           row["BusinessID"] = g.Key.Col1;
                           row["BusinessSEQ"] = g.Key.Col2;

                           return row;

                       })
                       .CopyToDataTable();
                ButtonText(panel_left, dt1, 1);
            }
            //var dt = menu = mbl.getMenuNo(Staff_CD, Base_DL.iniEntity.StoreType);

            ////var _result =(from r1 in dt.AsEnumerable()  group r1 by new { Char1 = r1.Field<string>("Char1"), } into g  select new { Char1 = g.Key.Char1,   BusinessSEQ = g.Max(x => x.Field<int>("BusinessSEQ")) }).ToArray();    //Group By
            //if (dt.Rows.Count > 0)
            //{
            //    var _result = dt.AsEnumerable().GroupBy(x => x.Field<string>("Char1")).Select(g => g.First()).CopyToDataTable();
            //    ButtonText(panel_left, _result, 1);
            //}
        }
        protected void ButtonText(Panel p, DataTable k0, int Gym)
        {
            IOrderedEnumerable<DataRow> result;
            if (Gym == 1)
                result = k0.Select().OrderBy(row => row["BusinessSEQ"]);
            else
                result = k0.Select().OrderBy(row => row["ProgramSEQ"]);
            var k = result.CopyToDataTable();
            // MainMenuLogin
            System.Windows.Forms.ToolTip ToolTip1 = new System.Windows.Forms.ToolTip();

            for (int j = 0; j < k.Rows.Count; j++)
            {
                var c = GetAllControls(p);
                for (int i = 0; i < c.Count(); i++)
                {
                    Control ctrl = c.ElementAt(i) as Control;

                    if (ctrl is CKM_Button)
                    {

                        ToolTip1.SetToolTip(((CKM_Button)ctrl), null);
                        if (Gym == 1 && k.Rows[j]["Char1"].ToString() != string.Empty && k.Rows[j]["BusinessSEQ"].ToString() != string.Empty)
                        {
                            if (((CKM_Button)ctrl).Name == "btnGym" + Convert.ToInt32(k.Rows[j]["BusinessSEQ"].ToString()))
                            {
                                ((CKM_Button)ctrl).Text = k.Rows[j]["Char1"].ToString();
                                ((CKM_Button)ctrl).Enabled = true;
                                ((CKM_Button)ctrl).TabIndex = Convert.ToInt32(k.Rows[j]["BusinessSEQ"].ToString());

                            }
                        }
                        else if (Gym == 0 && k.Rows[j]["ProgramID"].ToString() != string.Empty)
                        {
                            if (((CKM_Button)ctrl).Name == "btn_Proj" + Convert.ToInt32(k.Rows[j]["ProgramSEQ"].ToString()))
                            {
                                if (!Base_DL.iniEntity.IsDM_D30Used && k.Rows[j]["ProgramID_ID"].ToString() == "CashDrawerOpen")
                                {
                                    ((CKM_Button)ctrl).Text = "";
                                    ((CKM_Button)ctrl).Enabled = false;
                                    ((CKM_Button)ctrl).TabIndex = Convert.ToInt32(k.Rows[j]["ProgramSEQ"].ToString());
                                }
                                else
                                {
                                    ((CKM_Button)ctrl).Text = k.Rows[j]["ProgramID"].ToString();
                                    ((CKM_Button)ctrl).Enabled = true;
                                    ((CKM_Button)ctrl).TabIndex = Convert.ToInt32(k.Rows[j]["ProgramSEQ"].ToString());
                                }
                                //  ((CKM_Button)ctrl).Name = mope_data.PROID.ToString();
                                // ToolTip1.SetToolTip(((CKM_Button)ctrl),"");
                                //ToolTip1.SetToolTip(((CKM_Button)ctrl), ((CKM_Button)ctrl).Text);
                            }
                        }
                    }
                }
            }
        }
        //protected void ButtonText(Panel p, DataTable k0, int Gym)
        //{
        //    IOrderedEnumerable<DataRow> result;
        //    result = k0.Select().OrderBy(row => row["ProgramSEQ"]);
        //    var k = result.CopyToDataTable();
        //    System.Windows.Forms.ToolTip ToolTip1 = new System.Windows.Forms.ToolTip();

        //    for (int j = 0; j < k.Rows.Count; j++)
        //    {
        //        var c = GetAllControls(p);
        //        for (int i = 0; i < c.Count(); i++)
        //        {
        //            Control ctrl = c.ElementAt(i) as Control;

        //            if (ctrl is CKM_Button)
        //            {

        //                ToolTip1.SetToolTip(((CKM_Button)ctrl), null);
        //                if (Gym == 1 && k.Rows[j]["Char1"].ToString() != string.Empty && k.Rows[j]["BusinessSEQ"].ToString() != string.Empty)
        //                {
        //                    if (((CKM_Button)ctrl).Name == "btnGym" + Convert.ToInt32(k.Rows[j]["BusinessSEQ"].ToString()))
        //                    {
        //                        ((CKM_Button)ctrl).Text = k.Rows[j]["Char1"].ToString();
        //                        ((CKM_Button)ctrl).Enabled = true;
        //                    }
        //                }
        //                else if (Gym == 0 && k.Rows[j]["ProgramID"].ToString() != string.Empty)
        //                {
        //                    if (((CKM_Button)ctrl).Name == "btn_Proj" + Convert.ToInt32(k.Rows[j]["ProgramSEQ"].ToString()))
        //                    {
        //                        ((CKM_Button)ctrl).Text = k.Rows[j]["ProgramID"].ToString();
        //                        ((CKM_Button)ctrl).Enabled = true;
        //                        //  ((CKM_Button)ctrl).Name = mope_data.PROID.ToString();
        //                        // ToolTip1.SetToolTip(((CKM_Button)ctrl),"");
        //                        //ToolTip1.SetToolTip(((CKM_Button)ctrl), ((CKM_Button)ctrl).Text);
        //                    }
        //                }
        //            }
        //        }
        //    }
        //}
        private void Event_Designer(Panel pnl)
        {
            var c = GetAllControls(pnl);
            for (int i = 0; i < c.Count(); i++)
            {
                Control ctrl = c.ElementAt(i) as Control;
                if (ctrl is CKM_Button)
                {
                    if (pnl == panel_left)
                    {
                        ((CKM_Button)ctrl).Click += panelLeft_Click;
                    }
                    else
                    {
                        ((CKM_Button)ctrl).MouseLeave += panelRight_MouseLeave;
                        ((CKM_Button)ctrl).MouseEnter += panelRight_MouseEnter;
                        ((CKM_Button)ctrl).Click += panelRight_Click;
                    }
                }
            }
        }
        private void panelRight_MouseEnter(object sender, EventArgs e)
        {
            (sender as CKM_Button).BackgroundColor = CKM_Button.CKM_Color.Orange;
        }

        private void panelRight_MouseLeave(object sender, EventArgs e)
        {
            (sender as CKM_Button).BackgroundColor = CKM_Button.CKM_Color.Yellow;
        }
        private void panelRight_Click(object sender, EventArgs e)
        {
            OpenForm(sender);
        }
        private void ckM_Button4_Click(object sender, EventArgs e)
        {

        }

        protected Base_BL bbl = new Base_BL();
        private void btnClose_Click(object sender, EventArgs e)
        {
           // if (bbl.ShowMessage("Q003") == DialogResult.Yes)
                this.Close();
            //else
            //{
            //        btnClose.Focus();
            //}
            //    return;
        }
        private void panelLeft_Click(object sender, EventArgs e)
        {
            var c = GetAllControls(panel_right);
            int j = 0;
            for (int i = 0; i < c.Count(); i++)
            {
                Control ctrl = c.ElementAt(i) as Control;
                if (ctrl is CKM_Button)
                {
                    j++;
                    ((CKM_Button)ctrl).Text = "";
                    ((CKM_Button)ctrl).Enabled = false;
                    ToolTip ttp = new ToolTip();
                    ttp.SetToolTip(((CKM_Button)ctrl), null);
                    ((CKM_Button)ctrl).BackgroundColor = CKM_Button.CKM_Color.Yellow;
                    // ((CKM_Button)ctrl).Name = "btnPro" + (c.Count() - (j));
                }
            }
            CKM_Button btn = sender as CKM_Button;
            btnText = btn.Text;
            if (!string.IsNullOrWhiteSpace(btnText))
            {
                RightButton_Text(btnText, btn.TabIndex);
            }
        }
        private void RightButton_Text(string Text,int TabIndex)
        {
            var getDataa = menu.Select("Char1 = '" + Text + "' and BusinessSEQ ='" + TabIndex.ToString() + "'").CopyToDataTable();

            //var getDataa = menu.Select("Char1 = '" + Text + "'").CopyToDataTable();
            getDataa.DefaultView.Sort = "ProgramSEQ asc";
            getDataa.AcceptChanges();
            IOrderedEnumerable<DataRow> result;
            result = getDataa.Select().OrderBy(row => row["ProgramSEQ"]);
         var getData=   result.CopyToDataTable();
            if (getData.Rows.Count > 14)    // remove after processing
            {
                for (int k = 0; k < (getData.Rows.Count); k++)
                {
                    if (getData.Rows.Count > 14)
                    {
                        getData.Rows.RemoveAt(getData.Rows.Count -1);
                    }
                    else
                    {
                        break;
                    }

                }
                //MessageBox.Show("Menu item is over 14 and the extra menus can not be shown!");
                bbl.ShowMessage("I319");
            }
            if (getData.Rows.Count < 15)
            {
                if (getData != null)
                {
                    ButtonText(panel_right, getData, 0);
                }
            }
            else {
                MessageBox.Show("Too Much Menu Items Occurred!!!");
            }
        }
        public IEnumerable<Control> GetAllControls(Control root)
        {
            foreach (Control control in root.Controls)
            {
                foreach (Control child in GetAllControls(control))
                {
                    yield return child;
                }
            }
            yield return root;
        }
        private void OpenForm(object sender)
        {
            try
            {
                var programID = (sender as CKM_Button).Text;
                var exe_name = menu.Select("ProgramID = '" + programID + "'").CopyToDataTable().Rows[0]["ProgramID_ID"].ToString();

                if (Base_DL.iniEntity.IsDM_D30Used && exe_name == "CashDrawerOpen")
                {
                    try
                    {
                        CashDrawerOpen cdo_open = new CashDrawerOpen();
                        cdo_open.OpenCashDrawer();
                        //Base_DL.iniEntity.CDO_DISPLAY = new EPSON_TM30.CashDrawerOpen(); ;
                        //Base_DL.iniEntity.CDO_DISPLAY.OpenCashDrawer();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message + ex.StackTrace);
                    }
                    // op.OpenCashDrawer();
                }
                else

                {
                    //System.Uri u = new System.Uri(System.Reflection.Assembly.GetExecutingAssembly().CodeBase);
                    //string filePath = System.IO.Path.GetDirectoryName(u.LocalPath);
                    string filePath = "";
                    //System.Diagnostics.Debug 
                    if (Debugger.IsAttached || Login_BL.Islocalized)
                    {
                        System.Uri u = new System.Uri(System.Reflection.Assembly.GetExecutingAssembly().CodeBase);
                        filePath = System.IO.Path.GetDirectoryName(u.LocalPath);
                    }
                    else
                    {
                        filePath = @"C:\\SMS\\AppData";
                    }
                    string cmdLine = " " + "01" + " " + mse.StaffCD + " " + Login_BL.GetHostName();
                    //Process[] localByName = Process.GetProcessesByName(exe_name);
                    //if (localByName.Count() > 0)
                    //{
                    //    IntPtr handle = localByName[0].MainWindowHandle;
                    //    ShowWindow(handle, SW_SHOWMAXIMIZED);
                    //    return;
                    //}

                    //if (exe_name == "TempoRegiHanbaiTouroku" )
                    //{
                    //    try
                    //    {
                    //        if (Base_DL.iniEntity.IsDM_D30Used)
                    //        {
                    //            cdo.RemoveDisplay();
                    //        }
                    //        // Base_DL.Ini_Entity_CDP.CDO_DISPLAY.RemoveDisplay();
                    //    }
                    //    catch
                    //    {
                    //        MessageBox.Show("Reclick on HBT");
                    //    }
                    //}
                    RejectDisplay(exe_name);
                    Process[] localByName = Process.GetProcessesByName(exe_name);
                    if (localByName.Count() > 0)
                    {
                        //if (programID.TrimEnd() == "販売登録" || exe_name == "TempoRegiHanbaiTouroku" || exe_name == "TempoRegiHanbaiTouroku.exe")
                        //{
                        //  //  Login_BL bbl_1 = new Login_BL();
                        // //   bbl_1.Display_Service_Update(false);
                        //}
                            IntPtr handle = localByName[0].MainWindowHandle;
                        ShowWindow(handle, SW_SHOWMAXIMIZED);
                        SetForegroundWindow(handle);
                        return;
                    }


                    //if (P)
                    //   (sender as CKM_Button).Tag = System.Diagnostics.Process.Start(filePath + @"\" + exe_name + ".exe", cmdLine + "");   //original  

                    ///ptk
                    /// (sender as CKM_Button).Tag = System.Diagnostics.Process.Start(filePath + @"\" + exe_name + ".exe", cmdLine + "");
                    //if (programID.TrimEnd() == "販売登録" || exe_name == "TempoRegiHanbaiTouroku")
                    //{
                    //    try
                    //    {
                    //        using (Process exeProcess = Process.Start(filePath + @"\" + exe_name + ".exe", cmdLine + ""))
                    //        {
                    //            if (Base_DL.iniEntity.IsDM_D30Used)
                    //            {
                    //                exeProcess.WaitForExit();
                    //                cdo.SetDisplay(true, true, Base_DL.iniEntity.DefaultMessage);
                    //            }
                    //        }
                    //    }
                    //    catch (Exception ex)
                    //    {
                    //        MessageBox.Show(ex.Message + filePath + @"\" + exe_name + ".exe");
                    //    }

                    //}
                    //else
                    //{
                        (sender as CKM_Button).Tag = System.Diagnostics.Process.Start(filePath + @"\" + exe_name + ".exe", cmdLine + "");
                    //}
                    ///ptk
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("The program cannot locate to the specified file!!!");
            }
        }
        private void RejectDisplay(string Exename)
        {
            string[] str = new string[] {"TempoRegiHanbaiTouroku" ,"TempoRegiPoint", "TempoRegiRyousyuusyo",
                "TempoRegiTorihikiReceipt","TempoRegiRyougaeNyuuryoku", "TempoRegiShiharaiNyuuryoku", "TempoRegiTsurisenJyunbi","TempoRegiNyuukinTouroku" };

            foreach (var f in str)
            {
                if (Exename == f)
                {
                    try
                    {
                        if (Base_DL.iniEntity.IsDM_D30Used)
                        {
                            cdo.RemoveDisplay();
                        }
                        // Base_DL.Ini_Entity_CDP.CDO_DISPLAY.RemoveDisplay();
                    }
                    catch
                    {
                        MessageBox.Show("Reclick on HBT");
                    }
                    break;
                }
            }
        }
        private void ckM_Button1_Click(object sender, EventArgs e)
        {
            ForceToclose();
            // this.Hide();
            CapitalsportsLogin hln = new CapitalsportsLogin();
            this.Hide();
            hln.ShowDialog();
            this.Close();
        }

        private void btnProcess_Click(object sender, EventArgs e)
        {
            Store_Message sm = new Store_Message( mse);
            sm.ShowDialog(); ;
        }

        private void Capitalsports_MainMenu_FormClosing(object sender, FormClosingEventArgs e)
        {
            BL.Base_BL bbl = new Base_BL();
            if (bbl.ShowMessage("Q003") == DialogResult.Yes)
            {
                ForceToclose();
                e.Cancel = false;
            }
            else
                e.Cancel = true;
        }
        public void ForceToclose()
        {
            foreach (DataRow dr in menu.Rows)
            {
                var localByName = Process.GetProcessesByName(dr["ProgramID_ID"].ToString());
                if (localByName.Count() > 0)
                {

                    foreach (var process in localByName)
                    {
                        try
                        {
                            process.Kill();
                        }
                        catch
                        {

                        }
                    }
                }
            }
            try
            {
                Login_BL lbl = new Login_BL();
                try
                {
                    lbl.Display_Service_Update(false);
                    Thread.Sleep(3 * 1000);
                    lbl.Display_Service_Enabled(false);
                }
                catch {

                }
                cdo.RemoveDisplay();
               // true, true,Base_DL.iniEntity.DefaultMessage
              //  Base_DL.Ini_Entity_CDP.CDO_DISPLAY.RemoveDisplay();
            }
            catch
            {
                
            }
            
            //try
            //{
            //    m_Display.MarqueeType = DisplayMarqueeType.None;  // marquee close
            //    m_Display.DestroyWindow();                        // instance close we have created


            //    m_Display.ClearText();
            //    m_Display.DeviceEnabled = false;
            //    m_Display.Release();
            //    m_Display.Close();
            //}
            //catch(Exception ex)
            //{
            //   // MessageBox.Show(ex.Message);
            //}
        }

       
        protected void SetDisplay()
        {
            string strLogicalName = "LineDisplay";
            PosExplorer posExplorer = null;
            try
            {
                posExplorer = new PosExplorer();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message + " Cant call POSEXPLORE() function!  " + Environment.NewLine + " Skipped if Epson TM - M30 have not been installed.");
                goto End;
            }
            deviceInfo = posExplorer.GetDevice(DeviceType.LineDisplay, strLogicalName);
            m_Display = (LineDisplay)posExplorer.CreateInstance(deviceInfo);
            m_Display.Open();
            m_Display.Claim(1000);
            m_Display.DeviceEnabled = true;
            
            try
            {
                var val = GetMessages();
                m_Display.CharacterSet = 932;
                m_Display.CreateWindow(1, 0, 1, 20, 1, Encoding.GetEncoding(932).GetByteCount(val));
                m_Display.MarqueeFormat = DisplayMarqueeFormat.Walk;
                m_Display.MarqueeType = DisplayMarqueeType.Init;
                m_Display.MarqueeRepeatWait = 1000;
                m_Display.MarqueeUnitWait = 100;
                m_Display.DisplayText(val, DisplayTextMode.Normal);
                m_Display.MarqueeType = DisplayMarqueeType.Left;
            }
            catch (PosControlException pe)
            {
                MessageBox.Show(pe.Message);
            }
        End:
            {
                //
            }
        }
        protected string GetMessages()
        {
            var get = getd();
            var str = "";
            str += get.Rows[0]["Char1"] == null ? "" : get.Rows[0]["Char1"].ToString().Trim() + "     ";
            str += get.Rows[0]["Char2"] == null ? "" : get.Rows[0]["Char2"].ToString().Trim() + "     ";
            str += get.Rows[0]["Char3"] == null ? "" : get.Rows[0]["Char3"].ToString().Trim() + "     ";
            str += get.Rows[0]["Char4"] == null ? "" : get.Rows[0]["Char4"].ToString().Trim() + "     ";
            str += get.Rows[0]["Char5"] == null ? "" : get.Rows[0]["Char5"].ToString().Trim();
            int txt = Encoding.GetEncoding(932).GetByteCount(str);
            if (txt > 200)
            {
                str = str.Substring(0, 200);
            }
            return str;
        }
        protected DataTable getd()
        {
            var dt = new DataTable();
            var con= bdl.GetConnection();
            // SqlConnection conn = new SqlConnection("Data Source=202.223.48.145;Initial Catalog=CapitalSMS;Persist Security Info=True;User ID=sa;Password=admin123456!");
            SqlConnection conn = con;
            conn.Open();
            SqlCommand command = new SqlCommand("Select Char1, Char2, Char3, Char4,Char5 from [M_Multiporpose] where [Key]='1' and Id='326'", conn);
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            adapter.Fill(dt);
            conn.Close();
            return dt;
        }
        LineDisplay m_Display = null;
        DeviceInfo deviceInfo = null;
    }
}
