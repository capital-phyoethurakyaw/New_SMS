﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Deployment.Application;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using BL;
using Entity;
namespace MainMenu
{
    public partial class HaspoLogin : Form
    {

         








        Login_BL loginbl;
        M_Staff_Entity mse;
        public HaspoLogin()
        {
            InitializeComponent();
            if (ApplicationDeployment.IsNetworkDeployed)
            {
                label2.Text = ApplicationDeployment.CurrentDeployment.CurrentVersion.ToString(4);

            }
            else
                ckM_Button3.Visible = false;

        }

        private void HaspoLogin_Load(object sender, EventArgs e)
        {
            loginbl = new Login_BL();
        }

        private bool ErrorCheck()
        {
            if (string.IsNullOrWhiteSpace(txtOperatorCD.Text))
            {
                loginbl.ShowMessage("E101");
                txtOperatorCD.Focus();
                return false;
            }

            return true;
        }
        private M_Staff_Entity GetInfo()
        {
            mse = new M_Staff_Entity
            {
                StaffCD = txtOperatorCD.Text,
                Password = txtPassword.Text
            };
            return mse;
        }
        private void ckM_Button1_Click(object sender, EventArgs e)
        {
            Login_Click();
                //Base_BL bbl = new Base_BL();
                //bbl.ShowMessage("I001", "テスト", "テスト1");
             
        }
        private void Login_Click()
        {
            if (loginbl.ReadConfig() == false)
            {
                //起動時エラー    DB接続不可能
                this.Close();
                System.Environment.Exit(0);
            }
            if (ErrorCheck())
            {
                //共通処理　受取パラメータ、接続情報
                //コマンドライン引数より情報取得
                //Iniファイルより情報取得
                if (loginbl.ReadConfig() == false)
                {
                    //起動時エラー    DB接続不可能
                    this.Close();
                    System.Environment.Exit(0);
                }

                var mse = loginbl.MH_Staff_LoginSelect(GetInfo());
                if (mse.Rows.Count > 0)
                {
                    if (mse.Rows[0]["MessageID"].ToString() == "Allow")
                    {
                        if (loginbl.Check_RegisteredMenu(GetInfo()).Rows.Count > 0)
                        {
                            Haspo_MainMenu menuForm = new Haspo_MainMenu(GetInfo().StaffCD, GetInfo());
                            this.Hide();
                            menuForm.ShowDialog();
                            this.Close();
                        }
                        else
                        {
                            loginbl.ShowMessage("S018");
                            txtOperatorCD.Select();

                        }

                    }
                    else
                    {
                        loginbl.ShowMessage(mse.Rows[0]["MessageID"].ToString());
                        txtOperatorCD.Select();
                    }

                }
                else
                {
                    loginbl.ShowMessage("E101");
                    txtOperatorCD.Select();
                }

            }
        }
        private void HaspoLogin_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
                this.SelectNextControl(ActiveControl, true, true, true, true);

            else if (e.KeyData == Keys.F1)
            {
                this.Close();
                System.Environment.Exit(0);
            }
            else if (e.KeyData == Keys.F12)
            {
                Login_Click();

            }
            else if (e.KeyData == Keys.F11)
            {
                F11();

            }
        }
        private void F11()
        {
            if (ApplicationDeployment.IsNetworkDeployed)
            {
                var result = MessageBox.Show("Do you want to asynchronize AppData Files?", "Synchronous Update Information", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (result == DialogResult.Yes)
                {
                    this.Cursor = Cursors.WaitCursor;
                    FTPData ftp = new FTPData();
                    ftp.UpdateSyncData(Login_BL.SyncPath);
                    this.Cursor = Cursors.Default;
                    MessageBox.Show("Now AppData Files are updated!", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    // .. 
                }
                ckM_Button1.Focus();

            }
        }
        private void ckM_Button2_Click(object sender, EventArgs e)
        {
            this.Close();
            System.Environment.Exit(0);
        }

        private void ckM_Button3_Click(object sender, EventArgs e)
        {
            F11();
        }
    }
}
