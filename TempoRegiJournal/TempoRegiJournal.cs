﻿using Base.Client;
using BL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Windows.Forms;

namespace TempoRegiJournal
{
    public partial class TempoRegiJournal : ShopBaseForm
    {
        /// <summary>
        /// 製品名上段文字数
        /// </summary>
        private const int SKU_SHORTNAME_LENGTH = 23*2;

        /// <summary>
        /// BL
        /// </summary>
        TempoRegiJournal_BL bl = new TempoRegiJournal_BL();

        /// <summary>
        /// 店舗ジャーナル印刷 コンストラクタ
        /// </summary>
        public TempoRegiJournal()
        {
            InitializeComponent();
        }

        /// <summary>
        /// 画面読み込み処理
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TempoRegiJournal_Load(object sender, EventArgs e)
        {
            InProgramID = "TempoRegiJournal";
            string data = InOperatorCD;

            StartProgram();

            this.Text = "店舗ジャーナル印刷";
            this.btnProcess.Text = "プレビュー";

            SetRequireField();
        }

        /// <summary>
        /// オブジェクトの設定
        /// </summary>
        private void SetRequireField()
        {
            txtPrintDateFrom.Require(true);
            txtPrintDateTo.Require(true);

            txtPrintDateFrom.Text = txtPrintDateTo.Text = DateTime.Today.ToShortDateString();
            txtPrintDateFrom.Focus();
        }

        private void DisplayData()
        {
            txtPrintDateFrom.Focus();
            string data = InOperatorCD;
        }

        /// <summary>
        /// エラーチェック
        /// </summary>
        /// <returns>true=エラーなし、false=エラーあり</returns>
        /// <remarks>領収書印字日付はコントロールにチェック処理あり</remarks>
        public bool ErrorCheck()
        {
            if (string.IsNullOrWhiteSpace(txtPrintDateFrom.Text))
            {
                bl.ShowMessage("E102");
                txtPrintDateFrom.Focus();
                return false;
            }
            else if (string.IsNullOrWhiteSpace(txtPrintDateTo.Text))
            {
                bl.ShowMessage("E102");
                txtPrintDateTo.Focus();
                return false;
            }
            else if (!bbl.CheckDate(txtPrintDateFrom.Text))
            {
                // 日付エラー
                bbl.ShowMessage("E103");
                txtPrintDateFrom.Focus();
                return false;
            }
            else if (!bbl.CheckDate(txtPrintDateTo.Text))
            {
                // 日付エラー
                bbl.ShowMessage("E103");
                txtPrintDateTo.Focus();
                return false;
            }
            else if (Convert.ToDateTime(txtPrintDateFrom.Text).CompareTo(Convert.ToDateTime(txtPrintDateTo.Text)) > 0)
            {
                bl.ShowMessage("E130");
                txtPrintDateFrom.Focus();
                return false;
            }

            return true;
        }

        /// <summary>
        /// 画面終了処理
        /// </summary>
        protected override void EndSec()
        {
            this.Close();
        }

        /// <summary>
        /// ファンクション処理
        /// </summary>
        /// <param name="index"></param>
        public override void FunctionProcess(int index)
        {
            switch (index + 1)
            {
                case 2:
                    // プレビュー実行
                    Preview();
                    break;
            }
        }

        /// <summary>
        /// プレビュー実行
        /// </summary>
        private void Preview()
        {
            if (ErrorCheck())
            {
                var dataNum = bl.D_CheckStoreCalculation(StoreCD, txtPrintDateFrom.Text, txtPrintDateTo.Text);

                var value = ConvertDecimal(dataNum.Rows[0]["DataNum"]);
                if (string.IsNullOrWhiteSpace(value) || Convert.ToInt32(value) == 0)
                {
                    bl.ShowMessage("E244");
                }
                else
                {
                    var journal = bl.D_JournalSelect(StoreCD, txtPrintDateFrom.Text, txtPrintDateTo.Text);
                    if (journal.Rows.Count > 0)
                    {
                        OutputJournal(journal);
                    }
                    else
                    {
                        bl.ShowMessage("E128");
                    }
                }
            }
        }

        /// <summary>
        /// 商品引換券出力
        /// </summary>
        /// <param name="data">データ</param>
        private void OutputJournal(DataTable data)
        {
            var storeDataSet = CreateStoreDataSet(data, PrintCheckBox.Checked);
            if (storeDataSet.StoreTable.Count == 0)
            {
                bl.ShowMessage("E128");
            }
            else
            {
                // プレビューを開く
                var preview = new TempoRegiJournalPreview
                {
                    Store = storeDataSet,
                    StorePrinterName = StorePrinterName
                };

                preview.SetJournalDataSet();
                preview.ShowDialog();
            }
        }

        /// <summary>
        /// データセットを作成
        /// </summary>
        /// <param name="data">データベースから取得したデータテーブル</param>
        /// <param name="isPrint">販売明細を印刷するかどうか(印刷する=True、印刷しない=False)</param>
        /// <returns>データセット</returns>
        private StoreDataSet CreateStoreDataSet(DataTable data, bool isPrint)
        {
            var storeDataSet = new StoreDataSet();

            for (var index = 0; index < data.Rows.Count; index++)
            {
                var row = data.Rows[index];

                if (string.IsNullOrWhiteSpace(ConvertDateTime(row["IssueDate"], false)))
                {
                    // 発行日時がないデータは出力対象外
                    continue;
                }

                // 共通データ
                var salesNO = Convert.ToString(row["SalesNO"]);                             // 売上番号
                var storeReceiptPrint = Convert.ToString(row["StoreReceiptPrint"]);         // 店舗レシート表記
                var staffReceiptPrint = Convert.ToString(row["StaffReceiptPrint"]);         // 担当レシート表記

                #region 店舗データ
                if (storeDataSet.StoreTable.Rows.Count == 0)
                {
                    var store = storeDataSet.StoreTable.NewStoreTableRow();
                    store.Logo = (byte[])row["Logo"];
                    store.StoreName = Convert.ToString(row["StoreName"]);                       // 店舗名
                    store.Address1 = Convert.ToString(row["Address1"]);                         // 住所1
                    store.Address2 = Convert.ToString(row["Address2"]);                         // 住所2
                    store.TelphoneNO = Convert.ToString(row["TelephoneNO"]);                    // 電話番号
                    store.StoreReceiptPrint = Convert.ToString(row["StoreReceiptPrint"]);       // 店舗レシート表記
                                                                                                //
                    storeDataSet.StoreTable.Rows.Add(store);
                }
                #endregion // 店舗データ

                #region 販売データ
                var sales = storeDataSet.SalesTable.NewSalesTableRow();
                sales.StoreReceiptPrint = storeReceiptPrint;                                    // 店舗レシート表記
                sales.StaffReceiptPrint = staffReceiptPrint;                                    // 担当レシート表記
                sales.SalesNO = salesNO;                                                        // 売上番号
                //sales.IssueDate = ConvertDateTime(row["IssueDate"], false);                     // 発行日
                sales.IssueDate = ConvertDateTime(row["IssueDate"], true);                      // 発行日
                sales.IssueDateTime = ConvertDateTime(row["IssueDate"], false);//Convert.ToString(row["IssueDate"]);                       // 発行日時
                sales.JanCD = Convert.ToString(row["JanCD"]);                                   // JANCD

                var kakaku = ConvertDecimal(row["Kakaku"]);                                     // 価格

                //数量が0の場合は1として処理、その場合、単価は価格を割り当てる
                var salesSU = ConvertDecimal(row["SalesSU"]);
                if (string.IsNullOrWhiteSpace(salesSU))
                {
                    sales.SalesSU = "1";                                                        // 数量
                    sales.SalesUnitPrice = kakaku;                                              // 単価
                }
                else
                {
                    sales.SalesSU = salesSU;                                                    // 数量
                    sales.SalesUnitPrice = ConvertDecimal(row["SalesUnitPrice"]);               // 単価
                }

                sales.SalesGaku = kakaku;                                                       // 価格
                sales.SalesTax = ConvertDecimal(row["SalesTax"]);                               // 売上消費税額
                sales.SalesTaxRate = ConvertDecimal(row["SalesTaxRate"]) == "8" ? "*" : "";     // 税率
                sales.TotalGaku = ConvertDecimal(row["TotalGaku"]);                             // 販売合計額

                // 商品名
                var encoding = System.Text.Encoding.GetEncoding("Shift_JIS");

                var skuShortName = Convert.ToString(row["SKUShortName"]);
                byte[] skuShortNameBT = encoding.GetBytes(skuShortName);
                if (skuShortNameBT.Length < SKU_SHORTNAME_LENGTH)
                {
                    sales.SKUShortName1 = skuShortName;
                    sales.SKUShortName2 = "";
                }
                else
                {
                    sales.SKUShortName1 = encoding.GetString(skuShortNameBT, 0, SKU_SHORTNAME_LENGTH);
                    sales.SKUShortName2 = encoding.GetString(skuShortNameBT, SKU_SHORTNAME_LENGTH, skuShortNameBT.Length - SKU_SHORTNAME_LENGTH);
                }

                #region 合計データ
                sales.SumSalesSU = ConvertDecimal(row["SumSalesSU"]);                           // 小計数量
                sales.Subtotal = ConvertDecimal(row["Subtotal"]);                               // 小計金額
                sales.TargetAmount8 = ConvertDecimal(row["TargetAmount8"]);                     // 消費税対象額8%
                sales.ConsumptionTax8 = ConvertDecimal(row["ConsumptionTax8"]);                 // 内消費税等8%
                sales.TargetAmount10 = ConvertDecimal(row["TargetAmount10"]);                   // 消費税対象額10%
                sales.ConsumptionTax10 = ConvertDecimal(row["ConsumptionTax10"]);               // 内消費税等10%
                sales.Total = ConvertDecimal(row["Total"]);                                     // 合計
                #endregion // 合計データ

                #region 支払方法
                sales.PaymentName1 = Convert.ToString(row["PaymentName1"]);                     // 支払方法名1
                sales.PaymentAmount1 = ConvertDecimal(row["AmountPay1"]);                       // 支払方法額1
                sales.PaymentName2 = Convert.ToString(row["PaymentName2"]);                     // 支払方法名2
                sales.PaymentAmount2 = ConvertDecimal(row["AmountPay2"]);                       // 支払方法額2
                sales.PaymentName3 = Convert.ToString(row["PaymentName3"]);                     // 支払方法名3
                sales.PaymentAmount3 = ConvertDecimal(row["AmountPay3"]);                       // 支払方法額3
                sales.PaymentName4 = Convert.ToString(row["PaymentName4"]);                     // 支払方法名4
                sales.PaymentAmount4 = ConvertDecimal(row["AmountPay4"]);                       // 支払方法額4
                sales.PaymentName5 = Convert.ToString(row["PaymentName5"]);                     // 支払方法名5
                sales.PaymentAmount5 = ConvertDecimal(row["AmountPay5"]);                       // 支払方法額5
                sales.PaymentName6 = Convert.ToString(row["PaymentName6"]);                     // 支払方法名6
                sales.PaymentAmount6 = ConvertDecimal(row["AmountPay6"]);                       // 支払方法額6
                sales.PaymentName7 = Convert.ToString(row["PaymentName7"]);                     // 支払方法名7
                sales.PaymentAmount7 = ConvertDecimal(row["AmountPay7"]);                       // 支払方法額7
                sales.PaymentName8 = Convert.ToString(row["PaymentName8"]);                     // 支払方法名8
                sales.PaymentAmount8 = ConvertDecimal(row["AmountPay8"]);                       // 支払方法額8
                sales.PaymentName9 = Convert.ToString(row["PaymentName9"]);                     // 支払方法名9
                sales.PaymentAmount9 = ConvertDecimal(row["AmountPay9"]);                       // 支払方法額9
                sales.PaymentName10 = Convert.ToString(row["PaymentName10"]);                   // 支払方法名10
                sales.PaymentAmount10 = ConvertDecimal(row["AmountPay10"]);                     // 支払方法額10
                #endregion // 支払方法

                #region お釣りデータ
                sales.Refund = ConvertDecimal(row["Refund"]);                                   // 釣銭
                sales.DiscountGaku = ConvertDecimal(row["DiscountGaku"]);                       // 値引額
                #endregion // お釣りデータ
                //
                storeDataSet.SalesTable.Rows.Add(sales);

                #endregion // 販売データ

                #region 雑入金データ
                var miscDepositRegistDate = ConvertDateTime(row["MiscDepositRegistDate"], true);
                if (storeDataSet.MiscDepositTable.Where(s => s.StoreReceiptPrint == storeReceiptPrint && s.RegistDate == miscDepositRegistDate).FirstOrDefault() == null)
                {
                    var miscDeposit = storeDataSet.MiscDepositTable.NewMiscDepositTableRow();
                    miscDeposit.StoreReceiptPrint = storeReceiptPrint;                              // 雑入金店舗レシート表記
                    miscDeposit.StaffReceiptPrint = staffReceiptPrint;                              // 雑入金担当レシート表記
                    miscDeposit.SalesNO = salesNO;                                                  // 売上番号
                    miscDeposit.RegistDate = miscDepositRegistDate;                                 // 雑入金登録日
                    miscDeposit.DateTime1 = Convert.ToString(row["MiscDepositDate1"]);              // 雑入金日1
                    miscDeposit.Name1 = Convert.ToString(row["MiscDepositName1"]);                  // 雑入金名1
                    miscDeposit.Amount1 = ConvertDecimal(row["MiscDepositAmount1"]);                // 雑入金額1
                    miscDeposit.DateTime2 = Convert.ToString(row["MiscDepositDate2"]);              // 雑入金日2
                    miscDeposit.Name2 = Convert.ToString(row["MiscDepositName2"]);                  // 雑入金名2
                    miscDeposit.Amount2 = ConvertDecimal(row["MiscDepositAmount2"]);                // 雑入金額2
                    miscDeposit.DateTime3 = Convert.ToString(row["MiscDepositDate3"]);              // 雑入金日3
                    miscDeposit.Name3 = Convert.ToString(row["MiscDepositName3"]);                  // 雑入金名3
                    miscDeposit.Amount3 = ConvertDecimal(row["MiscDepositAmount3"]);                // 雑入金額3
                    miscDeposit.DateTime4 = Convert.ToString(row["MiscDepositDate4"]);              // 雑入金日4
                    miscDeposit.Name4 = Convert.ToString(row["MiscDepositName4"]);                  // 雑入金名4
                    miscDeposit.Amount4 = ConvertDecimal(row["MiscDepositAmount4"]);                // 雑入金額4
                    miscDeposit.DateTime5 = Convert.ToString(row["MiscDepositDate5"]);              // 雑入金日5
                    miscDeposit.Name5 = Convert.ToString(row["MiscDepositName5"]);                  // 雑入金名5
                    miscDeposit.Amount5 = ConvertDecimal(row["MiscDepositAmount5"]);                // 雑入金額5
                    miscDeposit.DateTime6 = Convert.ToString(row["MiscDepositDate6"]);              // 雑入金日6
                    miscDeposit.Name6 = Convert.ToString(row["MiscDepositName6"]);                  // 雑入金名6
                    miscDeposit.Amount6 = ConvertDecimal(row["MiscDepositAmount6"]);                // 雑入金額6
                    miscDeposit.DateTime7 = Convert.ToString(row["MiscDepositDate7"]);              // 雑入金日7
                    miscDeposit.Name7 = Convert.ToString(row["MiscDepositName7"]);                  // 雑入金名7
                    miscDeposit.Amount7 = ConvertDecimal(row["MiscDepositAmount7"]);                // 雑入金額7
                    miscDeposit.DateTime8 = Convert.ToString(row["MiscDepositDate8"]);              // 雑入金日8
                    miscDeposit.Name8 = Convert.ToString(row["MiscDepositName8"]);                  // 雑入金名8
                    miscDeposit.Amount8 = ConvertDecimal(row["MiscDepositAmount8"]);                // 雑入金額8
                    miscDeposit.DateTime9 = Convert.ToString(row["MiscDepositDate9"]);              // 雑入金日9
                    miscDeposit.Name9 = Convert.ToString(row["MiscDepositName9"]);                  // 雑入金名9
                    miscDeposit.Amount9 = ConvertDecimal(row["MiscDepositAmount9"]);                // 雑入金額9
                    miscDeposit.DateTime10 = Convert.ToString(row["MiscDepositDate10"]);            // 雑入金日10
                    miscDeposit.Name10 = Convert.ToString(row["MiscDepositName10"]);                // 雑入金名10
                    miscDeposit.Amount10 = ConvertDecimal(row["MiscDepositAmount10"]);              // 雑入金額10
                    //
                    storeDataSet.MiscDepositTable.Rows.Add(miscDeposit);
                }
                #endregion // 雑入金データ

                #region 入金データ
                var depositRegistDate = ConvertDateTime(row["DepositRegistDate"], true);
                if (storeDataSet.DepositTable.Where(s => s.StoreReceiptPrint == storeReceiptPrint && s.RegistDate == depositRegistDate).FirstOrDefault() == null)
                {
                    var deposit = storeDataSet.DepositTable.NewDepositTableRow();
                    deposit.StoreReceiptPrint = storeReceiptPrint;                              // 入金店舗レシート表記
                    deposit.StaffReceiptPrint = staffReceiptPrint;                              // 入金担当レシート表記
                    deposit.SalesNO = salesNO;                                                  // 売上番号
                    deposit.RegistDate = depositRegistDate;                                     // 入金登録日
                    deposit.CustomerCD = Convert.ToString(row["CustomerCD"]);                   // 入金元CD
                    deposit.CustomerName = Convert.ToString(row["CustomerName"]);               // 入金元名
                    deposit.DateTime1 = Convert.ToString(row["DepositDate1"]);                  // 入金日1
                    deposit.Name1 = Convert.ToString(row["DepositName1"]);                      // 入金区分名1
                    deposit.Amount1 = ConvertDecimal(row["DepositAmount1"]);                    // 入金額1
                    deposit.DateTime2 = Convert.ToString(row["DepositDate2"]);                  // 入金日2
                    deposit.Name2 = Convert.ToString(row["DepositName2"]);                      // 入金区分名2
                    deposit.Amount2 = ConvertDecimal(row["DepositAmount2"]);                    // 入金額2
                    deposit.DateTime3 = Convert.ToString(row["DepositDate3"]);                  // 入金日3
                    deposit.Name3 = Convert.ToString(row["DepositName3"]);                      // 入金区分名3
                    deposit.Amount3 = ConvertDecimal(row["DepositAmount3"]);                    // 入金額3
                    deposit.DateTime4 = Convert.ToString(row["DepositDate4"]);                  // 入金日4
                    deposit.Name4 = Convert.ToString(row["DepositName4"]);                      // 入金区分名4
                    deposit.Amount4 = ConvertDecimal(row["DepositAmount4"]);                    // 入金額4
                    deposit.DateTime5 = Convert.ToString(row["DepositDate5"]);                  // 入金日5
                    deposit.Name5 = Convert.ToString(row["DepositName5"]);                      // 入金区分名5
                    deposit.Amount5 = ConvertDecimal(row["DepositAmount5"]);                    // 入金額5
                    deposit.DateTime6 = Convert.ToString(row["DepositDate6"]);                  // 入金日6
                    deposit.Name6 = Convert.ToString(row["DepositName6"]);                      // 入金区分名6
                    deposit.Amount6 = ConvertDecimal(row["DepositAmount6"]);                    // 入金額6
                    deposit.DateTime7 = Convert.ToString(row["DepositDate7"]);                  // 入金日7
                    deposit.Name7 = Convert.ToString(row["DepositName7"]);                      // 入金区分名7
                    deposit.Amount7 = ConvertDecimal(row["DepositAmount7"]);                    // 入金額7
                    deposit.DateTime8 = Convert.ToString(row["DepositDate8"]);                  // 入金日8
                    deposit.Name8 = Convert.ToString(row["DepositName8"]);                      // 入金区分名8
                    deposit.Amount8 = ConvertDecimal(row["DepositAmount8"]);                    // 入金額8
                    deposit.DateTime9 = Convert.ToString(row["DepositDate9"]);                  // 入金日9
                    deposit.Name9 = Convert.ToString(row["DepositName9"]);                      // 入金区分名9
                    deposit.Amount9 = ConvertDecimal(row["DepositAmount9"]);                    // 入金額9
                    deposit.DateTime10 = Convert.ToString(row["DepositDate10"]);                // 入金日10
                    deposit.Name10 = Convert.ToString(row["DepositName10"]);                    // 入金区分名10
                    deposit.Amount10 = ConvertDecimal(row["DepositAmount10"]);                  // 入金額10
                                                                                                //
                    storeDataSet.DepositTable.Rows.Add(deposit);
                }
                #endregion // 入金データ

                #region 雑出金データ
                var miscPaymentRegistDate = ConvertDateTime(row["MiscPaymentRegistDate"], true);
                if (storeDataSet.MiscPaymentTable.Where(s => s.StoreReceiptPrint == storeReceiptPrint && s.RegistDate == miscPaymentRegistDate).FirstOrDefault() == null)
                {
                    var miscPayment = storeDataSet.MiscPaymentTable.NewMiscPaymentTableRow();
                    miscPayment.StoreReceiptPrint = storeReceiptPrint;                              // 雑出金店舗レシート表記
                    miscPayment.StaffReceiptPrint = staffReceiptPrint;                              // 雑出金担当レシート表記
                    miscPayment.SalesNO = salesNO;                                                  // 売上番号
                    miscPayment.RegistDate = miscPaymentRegistDate;                                 // 雑出金登録日
                    miscPayment.DateTime1 = Convert.ToString(row["MiscPaymentDate1"]);              // 雑出金日1
                    miscPayment.Name1 = Convert.ToString(row["MiscPaymentName1"]);                  // 雑出金名1
                    miscPayment.Amount1 = ConvertDecimal(row["MiscPaymentAmount1"]);                // 雑出金額1
                    miscPayment.DateTime2 = Convert.ToString(row["MiscPaymentDate2"]);              // 雑出金日2
                    miscPayment.Name2 = Convert.ToString(row["MiscPaymentName2"]);                  // 雑出金名2
                    miscPayment.Amount2 = ConvertDecimal(row["MiscPaymentAmount2"]);                // 雑出金額2
                    miscPayment.DateTime3 = Convert.ToString(row["MiscPaymentDate3"]);              // 雑出金日3
                    miscPayment.Name3 = Convert.ToString(row["MiscPaymentName3"]);                  // 雑出金名3
                    miscPayment.Amount3 = ConvertDecimal(row["MiscPaymentAmount3"]);                // 雑出金額3
                    miscPayment.DateTime4 = Convert.ToString(row["MiscPaymentDate4"]);              // 雑出金日4
                    miscPayment.Name4 = Convert.ToString(row["MiscPaymentName4"]);                  // 雑出金名4
                    miscPayment.Amount4 = ConvertDecimal(row["MiscPaymentAmount4"]);                // 雑出金額4
                    miscPayment.DateTime5 = Convert.ToString(row["MiscPaymentDate5"]);              // 雑出金日5
                    miscPayment.Name5 = Convert.ToString(row["MiscPaymentName5"]);                  // 雑出金名5
                    miscPayment.Amount5 = ConvertDecimal(row["MiscPaymentAmount5"]);                // 雑出金額5
                    miscPayment.DateTime6 = Convert.ToString(row["MiscPaymentDate6"]);              // 雑出金日6
                    miscPayment.Name6 = Convert.ToString(row["MiscPaymentName6"]);                  // 雑出金名6
                    miscPayment.Amount6 = ConvertDecimal(row["MiscPaymentAmount6"]);                // 雑出金額6
                    miscPayment.DateTime7 = Convert.ToString(row["MiscPaymentDate7"]);              // 雑出金日7
                    miscPayment.Name7 = Convert.ToString(row["MiscPaymentName7"]);                  // 雑出金名7
                    miscPayment.Amount7 = ConvertDecimal(row["MiscPaymentAmount7"]);                // 雑出金額7
                    miscPayment.DateTime8 = Convert.ToString(row["MiscPaymentDate8"]);              // 雑出金日8
                    miscPayment.Name8 = Convert.ToString(row["MiscPaymentName8"]);                  // 雑出金名8
                    miscPayment.Amount8 = ConvertDecimal(row["MiscPaymentAmount8"]);                // 雑出金額8
                    miscPayment.DateTime9 = Convert.ToString(row["MiscPaymentDate9"]);              // 雑出金日9
                    miscPayment.Name9 = Convert.ToString(row["MiscPaymentName9"]);                  // 雑出金名9
                    miscPayment.Amount9 = ConvertDecimal(row["MiscPaymentAmount9"]);                // 雑出金額9
                    miscPayment.DateTime10 = Convert.ToString(row["MiscPaymentDate10"]);            // 雑出金日10
                    miscPayment.Name10 = Convert.ToString(row["MiscPaymentName10"]);                // 雑出金名10
                    miscPayment.Amount10 = ConvertDecimal(row["MiscPaymentAmount10"]);              // 雑出金額10
                    //
                    storeDataSet.MiscPaymentTable.Rows.Add(miscPayment);
                }
                #endregion // 雑出金データ

                #region 両替データ
                var exchangeRegistDate = ConvertDateTime(row["ExchangeRegistDate"], true);
                if (storeDataSet.ExchangeTable.Where(s => s.StoreReceiptPrint == storeReceiptPrint && s.RegistDate == exchangeRegistDate).FirstOrDefault() == null)
                {
                    var exchange = storeDataSet.ExchangeTable.NewExchangeTableRow();
                    exchange.StoreReceiptPrint = storeReceiptPrint;                                 // 両替店舗レシート表記
                    exchange.StaffReceiptPrint = staffReceiptPrint;                                 // 両替担当レシート表記
                    exchange.SalesNO = salesNO;                                                     // 売上番号
                    exchange.RegistDate = exchangeRegistDate;                                       // 両替登録日
                    exchange.DateTime1 = Convert.ToString(row["ExchangeDate1"]);                    // 両替日1
                    exchange.Name1 = Convert.ToString(row["ExchangeName1"]);                        // 両替名1
                    exchange.Amount1 = ConvertDecimal(row["ExchangeAmount1"]);                      // 両替額1
                    exchange.Denomination1 = Convert.ToString(row["ExchangeDenomination1"]);        // 両替紙幣1
                    exchange.Count1 = ConvertDecimal(row["ExchangeCount1"]);                        // 両替枚数1
                    exchange.DateTime2 = Convert.ToString(row["ExchangeDate2"]);                    // 両替日2
                    exchange.Name2 = Convert.ToString(row["ExchangeName2"]);                        // 両替名2
                    exchange.Amount2 = ConvertDecimal(row["ExchangeAmount2"]);                      // 両替額2
                    exchange.Denomination2 = Convert.ToString(row["ExchangeDenomination2"]);        // 両替紙幣2
                    exchange.Count2 = ConvertDecimal(row["ExchangeCount2"]);                        // 両替枚数2
                    exchange.DateTime3 = Convert.ToString(row["ExchangeDate3"]);                    // 両替日3
                    exchange.Name3 = Convert.ToString(row["ExchangeName3"]);                        // 両替名3
                    exchange.Amount3 = ConvertDecimal(row["ExchangeAmount3"]);                      // 両替額3
                    exchange.Denomination3 = Convert.ToString(row["ExchangeDenomination3"]);        // 両替紙幣3
                    exchange.Count3 = ConvertDecimal(row["ExchangeCount3"]);                        // 両替枚数3
                    exchange.DateTime4 = Convert.ToString(row["ExchangeDate4"]);                    // 両替日4
                    exchange.Name4 = Convert.ToString(row["ExchangeName4"]);                        // 両替名4
                    exchange.Amount4 = ConvertDecimal(row["ExchangeAmount4"]);                      // 両替額4
                    exchange.Denomination4 = Convert.ToString(row["ExchangeDenomination4"]);        // 両替紙幣4
                    exchange.Count4 = ConvertDecimal(row["ExchangeCount4"]);                        // 両替枚数4
                    exchange.DateTime5 = Convert.ToString(row["ExchangeDate5"]);                    // 両替日5
                    exchange.Name5 = Convert.ToString(row["ExchangeName5"]);                        // 両替名5
                    exchange.Amount5 = ConvertDecimal(row["ExchangeAmount5"]);                      // 両替額5
                    exchange.Denomination5 = Convert.ToString(row["ExchangeDenomination5"]);        // 両替紙幣5
                    exchange.Count5 = ConvertDecimal(row["ExchangeCount5"]);                        // 両替枚数5
                    exchange.DateTime6 = Convert.ToString(row["ExchangeDate6"]);                    // 両替日6
                    exchange.Name6 = Convert.ToString(row["ExchangeName6"]);                        // 両替名6
                    exchange.Amount6 = ConvertDecimal(row["ExchangeAmount6"]);                      // 両替額6
                    exchange.Denomination6 = Convert.ToString(row["ExchangeDenomination6"]);        // 両替紙幣6
                    exchange.Count6 = ConvertDecimal(row["ExchangeCount6"]);                        // 両替枚数6
                    exchange.DateTime7 = Convert.ToString(row["ExchangeDate7"]);                    // 両替日7
                    exchange.Name7 = Convert.ToString(row["ExchangeName7"]);                        // 両替名7
                    exchange.Amount7 = ConvertDecimal(row["ExchangeAmount7"]);                      // 両替額7
                    exchange.Denomination7 = Convert.ToString(row["ExchangeDenomination7"]);        // 両替紙幣7
                    exchange.Count7 = ConvertDecimal(row["ExchangeCount7"]);                        // 両替枚数7
                    exchange.DateTime8 = Convert.ToString(row["ExchangeDate8"]);                    // 両替日8
                    exchange.Name8 = Convert.ToString(row["ExchangeName8"]);                        // 両替名8
                    exchange.Amount8 = ConvertDecimal(row["ExchangeAmount8"]);                      // 両替額8
                    exchange.Denomination8 = Convert.ToString(row["ExchangeDenomination8"]);        // 両替紙幣8
                    exchange.Count8 = ConvertDecimal(row["ExchangeCount8"]);                        // 両替枚数8
                    exchange.DateTime9 = Convert.ToString(row["ExchangeDate9"]);                    // 両替日9
                    exchange.Name9 = Convert.ToString(row["ExchangeName9"]);                        // 両替名9
                    exchange.Amount9 = ConvertDecimal(row["ExchangeAmount9"]);                      // 両替額9
                    exchange.Denomination9 = Convert.ToString(row["ExchangeDenomination9"]);        // 両替紙幣9
                    exchange.Count9 = ConvertDecimal(row["ExchangeCount9"]);                        // 両替枚数9
                    exchange.DateTime10 = Convert.ToString(row["ExchangeDate10"]);                  // 両替日10
                    exchange.Name10 = Convert.ToString(row["ExchangeName10"]);                      // 両替名10
                    exchange.Amount10 = ConvertDecimal(row["ExchangeAmount10"]);                    // 両替額10
                    exchange.Denomination10 = Convert.ToString(row["ExchangeDenomination10"]);      // 両替紙幣10
                    exchange.Count10 = ConvertDecimal(row["ExchangeCount10"]);                      // 両替枚数10
                    //
                    storeDataSet.ExchangeTable.Rows.Add(exchange);
                }
                #endregion // 両替データ

                #region 釣銭準備
                var changePreparationRegistDate = ConvertDateTime(row["ChangePreparationRegistDate"], true);
                if (storeDataSet.ChangePreparationTable.Where(s => s.StoreReceiptPrint == storeReceiptPrint && s.RegistDate == changePreparationRegistDate).FirstOrDefault() == null)
                {
                    var changePreparation = storeDataSet.ChangePreparationTable.NewChangePreparationTableRow();
                    changePreparation.StoreReceiptPrint = storeReceiptPrint;                                    // 両替店舗レシート表記
                    changePreparation.StaffReceiptPrint = staffReceiptPrint;                                    // 両替担当レシート表記
                    changePreparation.SalesNO = salesNO;                                                        // 売上番号
                    changePreparation.RegistDate = changePreparationRegistDate;                                 // 登録日
                    changePreparation.DateTime1 = Convert.ToString(row["ChangePreparationDate1"]);              // 釣銭準備日1
                    //changePreparation.Name1 = Convert.ToString(row["ChangePreparationName1"]);                  // 釣銭準備名1
                    changePreparation.Name1 = "現金";                                                           // 釣銭準備名1
                    changePreparation.Amount1 = ConvertDecimal(row["ChangePreparationAmount1"]);                // 釣銭準備額1
                    changePreparation.DateTime2 = Convert.ToString(row["ChangePreparationDate2"]);              // 釣銭準備日2
                    changePreparation.Name2 = Convert.ToString(row["ChangePreparationName2"]);                  // 釣銭準備名2
                    changePreparation.Amount2 = ConvertDecimal(row["ChangePreparationAmount2"]);                // 釣銭準備額2
                    changePreparation.DateTime3 = Convert.ToString(row["ChangePreparationDate3"]);              // 釣銭準備日3
                    changePreparation.Name3 = Convert.ToString(row["ChangePreparationName3"]);                  // 釣銭準備名3
                    changePreparation.Amount3 = ConvertDecimal(row["ChangePreparationAmount3"]);                // 釣銭準備額3
                    changePreparation.DateTime4 = Convert.ToString(row["ChangePreparationDate4"]);              // 釣銭準備日4
                    changePreparation.Name4 = Convert.ToString(row["ChangePreparationName4"]);                  // 釣銭準備名4
                    changePreparation.Amount4 = ConvertDecimal(row["ChangePreparationAmount4"]);                // 釣銭準備額4
                    changePreparation.DateTime5 = Convert.ToString(row["ChangePreparationDate5"]);              // 釣銭準備日5
                    changePreparation.Name5 = Convert.ToString(row["ChangePreparationName5"]);                  // 釣銭準備名5
                    changePreparation.Amount5 = ConvertDecimal(row["ChangePreparationAmount5"]);                // 釣銭準備額5
                    changePreparation.DateTime6 = Convert.ToString(row["ChangePreparationDate6"]);              // 釣銭準備日6
                    changePreparation.Name6 = Convert.ToString(row["ChangePreparationName6"]);                  // 釣銭準備名6
                    changePreparation.Amount6 = ConvertDecimal(row["ChangePreparationAmount6"]);                // 釣銭準備額6
                    changePreparation.DateTime7 = Convert.ToString(row["ChangePreparationDate7"]);              // 釣銭準備日7
                    changePreparation.Name7 = Convert.ToString(row["ChangePreparationName7"]);                  // 釣銭準備名7
                    changePreparation.Amount7 = ConvertDecimal(row["ChangePreparationAmount7"]);                // 釣銭準備額7
                    changePreparation.DateTime8 = Convert.ToString(row["ChangePreparationDate8"]);              // 釣銭準備日8
                    changePreparation.Name8 = Convert.ToString(row["ChangePreparationName8"]);                  // 釣銭準備名8
                    changePreparation.Amount8 = ConvertDecimal(row["ChangePreparationAmount8"]);                // 釣銭準備額8
                    changePreparation.DateTime9 = Convert.ToString(row["ChangePreparationDate9"]);              // 釣銭準備日9
                    changePreparation.Name9 = Convert.ToString(row["ChangePreparationName9"]);                  // 釣銭準備名9
                    changePreparation.Amount9 = ConvertDecimal(row["ChangePreparationAmount9"]);                // 釣銭準備額9
                    changePreparation.DateTime10 = Convert.ToString(row["ChangePreparationDate10"]);            // 釣銭準備日10
                    changePreparation.Name10 = Convert.ToString(row["ChangePreparationName10"]);                // 釣銭準備名10
                    changePreparation.Amount10 = ConvertDecimal(row["ChangePreparationAmount10"]);              // 釣銭準備額10
                    //
                    storeDataSet.ChangePreparationTable.Rows.Add(changePreparation);
                }
                #endregion // 釣銭準備

                #region 精算処理

                #region 精算処理 現金残高
                var cashBalanceRegistDate = ConvertDateTime(row["CashBalanceRegistDate"], true);
                if (storeDataSet.CashBalanceTable.Where(s => s.StoreReceiptPrint == storeReceiptPrint && s.RegistDate == cashBalanceRegistDate).FirstOrDefault() == null)
                {
                    var cashBalance = storeDataSet.CashBalanceTable.NewCashBalanceTableRow();
                    cashBalance.StoreReceiptPrint = storeReceiptPrint;                              // 店舗レシート表記
                    cashBalance.StaffReceiptPrint = staffReceiptPrint;                              // 担当レシート表記
                    cashBalance.SalesNO = salesNO;                                                  // 売上番号
                    cashBalance.RegistDate = cashBalanceRegistDate;                                 // 登録日
                    cashBalance.Num10000yen = ConvertDecimal(row["10000yenNum"]);                   // 現金残高10,000枚数
                    cashBalance.Num5000yen = ConvertDecimal(row["5000yenNum"]);                     // 現金残高5,000枚数
                    cashBalance.Num2000yen = ConvertDecimal(row["2000yenNum"]);                     // 現金残高2,000枚数
                    cashBalance.Num1000yen = ConvertDecimal(row["1000yenNum"]);                     // 現金残高1,000枚数
                    cashBalance.Num500yen = ConvertDecimal(row["500yenNum"]);                       // 現金残高500枚数
                    cashBalance.Num100yen = ConvertDecimal(row["100yenNum"]);                       // 現金残高100枚数
                    cashBalance.Num50yen = ConvertDecimal(row["50yenNum"]);                         // 現金残高50枚数
                    cashBalance.Num10yen = ConvertDecimal(row["10yenNum"]);                         // 現金残高10枚数
                    cashBalance.Num5yen = ConvertDecimal(row["5yenNum"]);                           // 現金残高5枚数
                    cashBalance.Num1yen = ConvertDecimal(row["1yenNum"]);                           // 現金残高1枚数
                    cashBalance.Gaku10000yen = ConvertDecimal(row["10000yenGaku"]);                 // 現金残高10,000金額
                    cashBalance.Gaku5000yen = ConvertDecimal(row["5000yenGaku"]);                   // 現金残高5,000金額
                    cashBalance.Gaku2000yen = ConvertDecimal(row["2000yenGaku"]);                   // 現金残高2,000金額
                    cashBalance.Gaku1000yen = ConvertDecimal(row["1000yenGaku"]);                   // 現金残高1,000金額
                    cashBalance.Gaku500yen = ConvertDecimal(row["500yenGaku"]);                     // 現金残高500金額
                    cashBalance.Gaku100yen = ConvertDecimal(row["100yenGaku"]);                     // 現金残高100金額
                    cashBalance.Gaku50yen = ConvertDecimal(row["50yenGaku"]);                       // 現金残高50金額
                    cashBalance.Gaku10yen = ConvertDecimal(row["10yenGaku"]);                       // 現金残高10金額
                    cashBalance.Gaku5yen = ConvertDecimal(row["5yenGaku"]);                         // 現金残高5金額
                    cashBalance.Gaku1yen = ConvertDecimal(row["1yenGaku"]);                         // 現金残高1金額
                    cashBalance.Etcyen = ConvertDecimal(row["Etcyen"]);                             // その他金額
                    cashBalance.Change = ConvertDecimal(row["Change"]);                             // 釣銭準備金
                    cashBalance.TotalGaku = ConvertDecimal(row["DepositGaku"]);                     // 現金残高 現金売上(+)
                    cashBalance.CashDeposit = ConvertDecimal(row["CashDeposit"]);                   // 現金残高 現金入金(+)
                    cashBalance.CashPayment = ConvertDecimal(row["CashPayment"]);                   // 現金残高 現金支払(-)
                    cashBalance.CashBalance = ConvertDecimal(row["CashBalance"]);                   // 現金残高 その他金額～現金残高現金支払(-)までの合計
                    cashBalance.ComputerTotal = ConvertDecimal(row["ComputerTotal"]);               // ｺﾝﾋﾟｭｰﾀ計 現金残高 10,000金額～現金残高1金額までの合計
                    cashBalance.CashShortage = ConvertDecimal(row["CashShortage"]);                 // 現金残高 現金過不足
                    //
                    storeDataSet.CashBalanceTable.Rows.Add(cashBalance);

                    #region 精算処理 総売
                    if (storeDataSet.TotalSalesTable.Where(s => s.RegistDate == cashBalance.RegistDate).FirstOrDefault() == null)
                    {
                        var totalSales = storeDataSet.TotalSalesTable.NewTotalSalesTableRow();
                        totalSales.StaffReceiptPrint = staffReceiptPrint;                               // 担当レシート表記
                        totalSales.RegistDate = cashBalance.RegistDate;                                 // 登録日
                        totalSales.SalesNO = salesNO;                                                   // 売上番号
                        totalSales.SalesNOCount = ConvertDecimal(row["SalesNOCount"]);                  // 総売 伝票数
                        totalSales.CustomerCDCount = ConvertDecimal(row["CustomerCDCount"]);            // 総売 客数(人)
                        totalSales.SalesSUSum = ConvertDecimal(row["SalesSUSum"]);                      // 総売 売上数量
                        totalSales.TotalGakuSum = ConvertDecimal(row["TotalGakuSum"]);                  // 総売 売上金額
                        //
                        storeDataSet.TotalSalesTable.Rows.Add(totalSales);
                    }
                    #endregion // 精算処理 総売

                    #region 精算処理 取引別
                    if (storeDataSet.ByTransactionTable.Where(s => s.RegistDate == cashBalance.RegistDate).FirstOrDefault() == null)
                    {
                        var byTransaction = storeDataSet.ByTransactionTable.NewByTransactionTableRow();
                        byTransaction.StaffReceiptPrint = staffReceiptPrint;                                    // 担当レシート表記
                        byTransaction.RegistDate = cashBalance.RegistDate;                                      // 登録日
                        byTransaction.SalesNO = salesNO;                                                        // 売上番号
                        byTransaction.ForeignTaxableAmount = ConvertDecimal(row["ForeignTaxableAmount"]);       // 取引別 外税対象額
                        byTransaction.TaxableAmount = ConvertDecimal(row["TaxableAmount"]);                     // 取引別 内税対象額
                        byTransaction.TaxExemptionAmount = ConvertDecimal(row["TaxExemptionAmount"]);           // 取引別 非課税対象額
                        byTransaction.TotalWithoutTax = ConvertDecimal(row["TotalWithoutTax"]);                 // 取引別 税抜合計
                        byTransaction.Tax = ConvertDecimal(row["Tax"]);                                         // 取引別 内税
                        byTransaction.OutsideTax = ConvertDecimal(row["OutsideTax"]);                           // 取引別 外税
                        byTransaction.ConsumptionTax = ConvertDecimal(row["ConsumptionTax"]);                   // 取引別 消費税計
                        byTransaction.ForeignTaxableAmount = ConvertDecimal(row["ForeignTaxableAmount"]);       // 取引別 外税対象額
                        byTransaction.TaxIncludedTotal = ConvertDecimal(row["TaxIncludedTotal"]);               // 取引別 税込合計
                        byTransaction.DiscountGaku = ConvertDecimal(row["DiscountGaku"]);                       // 取引別 値引額
                        //
                        storeDataSet.ByTransactionTable.Rows.Add(byTransaction);
                    }
                    #endregion // 精算処理 取引別

                    #region 精算処理 決済別
                    if (storeDataSet.BySettlementTable.Where(s => s.RegistDate == cashBalance.RegistDate).FirstOrDefault() == null)
                    {
                        var bySettlement = storeDataSet.BySettlementTable.NewBySettlementTableRow();
                        bySettlement.StaffReceiptPrint = staffReceiptPrint;                             // 担当レシート表記
                        bySettlement.RegistDate = cashBalance.RegistDate;                               // 登録日
                        bySettlement.SalesNO = salesNO;                                                 // 売上番号
                        bySettlement.DenominationName1 = Convert.ToString(row["DenominationName1"]);    // 決済別 金種区分名1
                        bySettlement.Kingaku1 = ConvertDecimal(row["Kingaku1"]);                        // 決済別 金額1
                        bySettlement.DenominationName2 = Convert.ToString(row["DenominationName2"]);    // 決済別 金種区分名2
                        bySettlement.Kingaku2 = ConvertDecimal(row["Kingaku2"]);                        // 決済別 金額2
                        bySettlement.DenominationName3 = Convert.ToString(row["DenominationName3"]);    // 決済別 金種区分名3
                        bySettlement.Kingaku3 = ConvertDecimal(row["Kingaku3"]);                        // 決済別 金額3
                        bySettlement.DenominationName4 = Convert.ToString(row["DenominationName4"]);    // 決済別 金種区分名4
                        bySettlement.Kingaku4 = ConvertDecimal(row["Kingaku4"]);                        // 決済別 金額4
                        bySettlement.DenominationName5 = Convert.ToString(row["DenominationName5"]);    // 決済別 金種区分名5
                        bySettlement.Kingaku5 = ConvertDecimal(row["Kingaku5"]);                        // 決済別 金額5
                        bySettlement.DenominationName6 = Convert.ToString(row["DenominationName6"]);    // 決済別 金種区分名6
                        bySettlement.Kingaku6 = ConvertDecimal(row["Kingaku6"]);                        // 決済別 金額6
                        bySettlement.DenominationName7 = Convert.ToString(row["DenominationName7"]);    // 決済別 金種区分名7
                        bySettlement.Kingaku7 = ConvertDecimal(row["Kingaku7"]);                        // 決済別 金額7
                        bySettlement.DenominationName8 = Convert.ToString(row["DenominationName8"]);    // 決済別 金種区分名8
                        bySettlement.Kingaku8 = ConvertDecimal(row["Kingaku8"]);                        // 決済別 金額8
                        bySettlement.DenominationName9 = Convert.ToString(row["DenominationName9"]);    // 決済別 金種区分名9
                        bySettlement.Kingaku9 = ConvertDecimal(row["Kingaku9"]);                        // 決済別 金額9
                        bySettlement.DenominationName10 = Convert.ToString(row["DenominationName10"]);  // 決済別 金種区分名10
                        bySettlement.Kingaku10 = ConvertDecimal(row["Kingaku10"]);                      // 決済別 金額10
                        //
                        storeDataSet.BySettlementTable.Rows.Add(bySettlement);
                    }
                    #endregion // 精算処理 決済別

                    #region 精算処理 入金計
                    if (storeDataSet.DepositTotalTable.Where(s => s.RegistDate == cashBalance.RegistDate).FirstOrDefault() == null)
                    {
                        var depositTotal = storeDataSet.DepositTotalTable.NewDepositTotalTableRow();
                        depositTotal.StaffReceiptPrint = staffReceiptPrint;                             // 担当レシート表記
                        depositTotal.RegistDate = cashBalance.RegistDate;                               // 登録日
                        depositTotal.SalesNO = salesNO;                                                 // 売上番号
                        depositTotal.Transfer = ConvertDecimal(row["DepositTransfer"]);                 // 入金計 振込
                        depositTotal.Cash = ConvertDecimal(row["DepositCash"]);                         // 入金計 現金
                        depositTotal.Check = ConvertDecimal(row["DepositCheck"]);                       // 入金計 小切手
                        depositTotal.Bill = ConvertDecimal(row["DepositBill"]);                         // 入金計 手形
                        depositTotal.Offset = ConvertDecimal(row["DepositOffset"]);                     // 入金計 相殺
                        depositTotal.Adjustment = ConvertDecimal(row["DepositAdjustment"]);             // 入金計 調整
                        //
                        storeDataSet.DepositTotalTable.Rows.Add(depositTotal);
                    }
                    #endregion // 精算処理 入金計

                    #region 精算処理 支払計
                    if (storeDataSet.PaymentTotalTable.Where(s => s.RegistDate == cashBalance.RegistDate).FirstOrDefault() == null)
                    {
                        var paymentTotal = storeDataSet.PaymentTotalTable.NewPaymentTotalTableRow();
                        paymentTotal.StaffReceiptPrint = staffReceiptPrint;                             // 担当レシート表記
                        paymentTotal.RegistDate = cashBalance.RegistDate;                               // 登録日
                        paymentTotal.SalesNO = salesNO;                                                 // 売上番号
                        paymentTotal.Transfer = ConvertDecimal(row["PaymentTransfer"]);                 // 支払計 振込
                        paymentTotal.Cash = ConvertDecimal(row["PaymentCash"]);                         // 支払計 現金
                        paymentTotal.Check = ConvertDecimal(row["PaymentCheck"]);                       // 支払計 小切手
                        paymentTotal.Bill = ConvertDecimal(row["PaymentBill"]);                         // 支払計 手形
                        paymentTotal.Offset = ConvertDecimal(row["PaymentOffset"]);                     // 支払計 振込
                        paymentTotal.Adjustment = ConvertDecimal(row["PaymentAdjustment"]);             // 支払計 相殺
                        //
                        storeDataSet.PaymentTotalTable.Rows.Add(paymentTotal);
                    }
                    #endregion // 精算処理 支払計

                    #region 精算処理 他金額
                    if (storeDataSet.OtherAmountTable.Where(s => s.RegistDate == cashBalance.RegistDate).FirstOrDefault() == null)
                    {
                        var otherAmount = storeDataSet.OtherAmountTable.NewOtherAmountTableRow();
                        otherAmount.StaffReceiptPrint = staffReceiptPrint;                              // 担当レシート表記
                        otherAmount.RegistDate = cashBalance.RegistDate;                                // 登録日
                        otherAmount.SalesNO = salesNO;                                                  // 売上番号
                        otherAmount.Returns = ConvertDecimal(row["OtherAmountReturns"]);                // 他金額 返品
                        otherAmount.Discount = ConvertDecimal(row["OtherAmountDiscount"]);              // 他金額 値引
                        otherAmount.Cancel = ConvertDecimal(row["OtherAmountCancel"]);                  // 他金額 取消
                        otherAmount.Delivery = ConvertDecimal(row["OtherAmountDelivery"]);              // 他金額 配達
                        otherAmount.ExchangeCount = ConvertDecimal(row["ExchangeCount"]);               // 両替回数
                        //
                        storeDataSet.OtherAmountTable.Rows.Add(otherAmount);
                    }
                    #endregion // 精算処理 他金額

                    #region 精算処理 時間帯別(税込)
                    if (storeDataSet.ByTimeZoneTaxIncludedTable.Where(s => s.RegistDate == cashBalance.RegistDate).FirstOrDefault() == null)
                    {
                        var byTimeZoneTaxIncluded = storeDataSet.ByTimeZoneTaxIncludedTable.NewByTimeZoneTaxIncludedTableRow();
                        byTimeZoneTaxIncluded.StaffReceiptPrint = staffReceiptPrint;                                        // 担当レシート表記
                        byTimeZoneTaxIncluded.RegistDate = cashBalance.RegistDate;                                          // 登録日
                        byTimeZoneTaxIncluded.SalesNO = salesNO;                                                            // 売上番号
                        byTimeZoneTaxIncluded.From0000to0100 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0000_0100"]);      // 時間帯別(税込) 00:00～01:00
                        byTimeZoneTaxIncluded.From0100to0200 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0100_0200"]);      // 時間帯別(税込) 01:00～02:00
                        byTimeZoneTaxIncluded.From0200to0300 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0200_0300"]);      // 時間帯別(税込) 02:00～03:00
                        byTimeZoneTaxIncluded.From0300to0400 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0300_0400"]);      // 時間帯別(税込) 03:00～04:00
                        byTimeZoneTaxIncluded.From0400to0500 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0400_0500"]);      // 時間帯別(税込) 04:00～05:00
                        byTimeZoneTaxIncluded.From0500to0600 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0500_0600"]);      // 時間帯別(税込) 05:00～06:00
                        byTimeZoneTaxIncluded.From0600to0700 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0600_0700"]);      // 時間帯別(税込) 06:00～07:00
                        byTimeZoneTaxIncluded.From0700to0800 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0700_0800"]);      // 時間帯別(税込) 07:00～08:00
                        byTimeZoneTaxIncluded.From0800to0900 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0800_0900"]);      // 時間帯別(税込) 08:00～09:00
                        byTimeZoneTaxIncluded.From0900to1000 = ConvertDecimal(row["ByTimeZoneTaxIncluded_0900_1000"]);      // 時間帯別(税込) 09:00～10:00
                        byTimeZoneTaxIncluded.From1000to1100 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1000_1100"]);      // 時間帯別(税込) 10:00～11:00
                        byTimeZoneTaxIncluded.From1100to1200 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1100_1200"]);      // 時間帯別(税込) 11:00～12:00
                        byTimeZoneTaxIncluded.From1200to1300 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1200_1300"]);      // 時間帯別(税込) 12:00～13:00
                        byTimeZoneTaxIncluded.From1300to1400 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1300_1400"]);      // 時間帯別(税込) 13:00～14:00
                        byTimeZoneTaxIncluded.From1400to1500 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1400_1500"]);      // 時間帯別(税込) 14:00～15:00
                        byTimeZoneTaxIncluded.From1500to1600 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1500_1600"]);      // 時間帯別(税込) 15:00～16:00
                        byTimeZoneTaxIncluded.From1600to1700 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1600_1700"]);      // 時間帯別(税込) 16:00～17:00
                        byTimeZoneTaxIncluded.From1700to1800 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1700_1800"]);      // 時間帯別(税込) 17:00～18:00
                        byTimeZoneTaxIncluded.From1800to1900 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1800_1900"]);      // 時間帯別(税込) 18:00～19:00
                        byTimeZoneTaxIncluded.From1900to2000 = ConvertDecimal(row["ByTimeZoneTaxIncluded_1900_2000"]);      // 時間帯別(税込) 19:00～20:00
                        byTimeZoneTaxIncluded.From2000to2100 = ConvertDecimal(row["ByTimeZoneTaxIncluded_2000_2100"]);      // 時間帯別(税込) 20:00～21:00
                        byTimeZoneTaxIncluded.From2100to2200 = ConvertDecimal(row["ByTimeZoneTaxIncluded_2100_2200"]);      // 時間帯別(税込) 21:00～22:00
                        byTimeZoneTaxIncluded.From2200to2300 = ConvertDecimal(row["ByTimeZoneTaxIncluded_2200_2300"]);      // 時間帯別(税込) 22:00～23:00
                        byTimeZoneTaxIncluded.From2300to2400 = ConvertDecimal(row["ByTimeZoneTaxIncluded_2300_2400"]);      // 時間帯別(税込) 23:00～24:00
                        //
                        storeDataSet.ByTimeZoneTaxIncludedTable.Rows.Add(byTimeZoneTaxIncluded);
                    }
                    #endregion // 精算処理 時間帯別(税込)

                    #region 精算処理 時間帯別件数
                    if (storeDataSet.ByTimeZoneSalesTable.Where(s => s.RegistDate == cashBalance.RegistDate).FirstOrDefault() == null)
                    {
                        var byTimeZoneSales = storeDataSet.ByTimeZoneSalesTable.NewByTimeZoneSalesTableRow();
                        byTimeZoneSales.StaffReceiptPrint = staffReceiptPrint;                                              // 担当レシート表記
                        byTimeZoneSales.RegistDate = cashBalance.RegistDate;                                                // 登録日
                        byTimeZoneSales.SalesNO = salesNO;                                                                  // 売上番号
                        byTimeZoneSales.From0000to0100 = ConvertDecimal(row["ByTimeZoneSalesNO_0000_0100"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From0100to0200 = ConvertDecimal(row["ByTimeZoneSalesNO_0100_0200"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From0200to0300 = ConvertDecimal(row["ByTimeZoneSalesNO_0200_0300"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From0300to0400 = ConvertDecimal(row["ByTimeZoneSalesNO_0300_0400"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From0400to0500 = ConvertDecimal(row["ByTimeZoneSalesNO_0400_0500"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From0500to0600 = ConvertDecimal(row["ByTimeZoneSalesNO_0500_0600"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From0600to0700 = ConvertDecimal(row["ByTimeZoneSalesNO_0600_0700"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From0700to0800 = ConvertDecimal(row["ByTimeZoneSalesNO_0700_0800"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From0800to0900 = ConvertDecimal(row["ByTimeZoneSalesNO_0800_0900"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From0900to1000 = ConvertDecimal(row["ByTimeZoneSalesNO_0900_1000"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1000to1100 = ConvertDecimal(row["ByTimeZoneSalesNO_1000_1100"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1100to1200 = ConvertDecimal(row["ByTimeZoneSalesNO_1100_1200"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1200to1300 = ConvertDecimal(row["ByTimeZoneSalesNO_1200_1300"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1300to1400 = ConvertDecimal(row["ByTimeZoneSalesNO_1300_1400"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1400to1500 = ConvertDecimal(row["ByTimeZoneSalesNO_1400_1500"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1500to1600 = ConvertDecimal(row["ByTimeZoneSalesNO_1500_1600"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1600to1700 = ConvertDecimal(row["ByTimeZoneSalesNO_1600_1700"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1700to1800 = ConvertDecimal(row["ByTimeZoneSalesNO_1700_1800"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1800to1900 = ConvertDecimal(row["ByTimeZoneSalesNO_1800_1900"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From1900to2000 = ConvertDecimal(row["ByTimeZoneSalesNO_1900_2000"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From2000to2100 = ConvertDecimal(row["ByTimeZoneSalesNO_2000_2100"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From2100to2200 = ConvertDecimal(row["ByTimeZoneSalesNO_2100_2200"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From2200to2300 = ConvertDecimal(row["ByTimeZoneSalesNO_2200_2300"]);                // 時間帯別件数 23:00～24:00
                        byTimeZoneSales.From2300to2400 = ConvertDecimal(row["ByTimeZoneSalesNO_2300_2400"]);                // 時間帯別件数 23:00～24:00
                        //
                        storeDataSet.ByTimeZoneSalesTable.Rows.Add(byTimeZoneSales);
                    }
                    #endregion // 精算処理 時間帯別件数
                }
                #endregion // 精算処理 現金残高

                #endregion // 精算処理
            }

            #region 出力設定

            if(storeDataSet.StoreTable.Rows.Count > 0)
            {
                // 各明細部印刷有無を印刷フラグで設定
                storeDataSet.StoreTable[0].DispSales = isPrint;                 // 販売
                storeDataSet.StoreTable[0].DispMiscDeposit = isPrint;           // 雑入金
                storeDataSet.StoreTable[0].DispDeposit = isPrint;               // 入金
                storeDataSet.StoreTable[0].DispMiscPayment = isPrint;           // 雑出金
                storeDataSet.StoreTable[0].DispExchange = isPrint;              // 両替
                storeDataSet.StoreTable[0].DispChangePreparation = isPrint;     // 釣銭準備

                if (isPrint)
                {
                    // 印刷するフラグON時、各明細部の出力件数が0件の場合は印刷フラグOFF

                    // 販売
                    if (storeDataSet.StoreTable.Count == 0)
                    {
                        storeDataSet.StoreTable[0].DispSales = false;
                    }

                    // 雑入金
                    if (storeDataSet.MiscDepositTable.Count == 0)
                    {
                        storeDataSet.StoreTable[0].DispMiscDeposit = false;
                    }

                    // 入金
                    if (storeDataSet.DepositTable.Count == 0)
                    {
                        storeDataSet.StoreTable[0].DispDeposit = false;
                    }

                    // 雑出金
                    if (storeDataSet.MiscPaymentTable.Count == 0)
                    {
                        storeDataSet.StoreTable[0].DispMiscPayment = false;
                    }

                    // 両替
                    if (storeDataSet.ExchangeTable.Count == 0)
                    {
                        storeDataSet.StoreTable[0].DispExchange = false;
                    }

                    // 釣銭準備
                    if (storeDataSet.ChangePreparationTable.Count == 0)
                    {
                        storeDataSet.StoreTable[0].DispChangePreparation = false;
                    }
                }
            }

            #endregion // 出力設定

            return storeDataSet;
        }

        /// <summary>
        /// 日時をyyyy/MM/dd hh:miで取得
        /// </summary>
        /// <param name="value">元の日時</param>
        /// <returns>日時</returns>
        private string ConvertDateTime(object value, bool dateOnly)
        {
            var result = string.Empty;

            var dateTime = Convert.ToString(value);
            if(!string.IsNullOrWhiteSpace(dateTime))
            {
                result = dateOnly ? dateTime.Substring(0, "yyyy/MM/dd".Length) : dateTime.Substring(0, dateTime.LastIndexOf(':'));
            }

            return result;
        }

        /// <summary>
        /// Decimal型で取得
        /// </summary>
        /// <param name="value">元の値</param>
        /// <returns>Decimal型の値</returns>
        /// <remarks>NULL値は0で返す</remarks>
        private string ConvertDecimal(object value)
        {
            var result = 0;

            if (string.IsNullOrWhiteSpace(value.ToString()))
            {
                return "";
            }
            else
            {
                var pos = value.ToString().LastIndexOf('.');
                if (pos < 0)
                {
                    result = string.IsNullOrWhiteSpace(value.ToString()) ? 0 : Convert.ToInt32(value.ToString());
                }
                else
                {
                    result = string.IsNullOrWhiteSpace(value.ToString()) ? 0 : Convert.ToInt32(value.ToString().Substring(0, pos));
                }

                return string.Format("{0:#,0}", result);
            }
        }

        /// <summary>
        /// 文字列を指定文字数で分割
        /// </summary>
        /// <param name="value">文字列</param>
        /// <param name="count">分割する文字数</param>
        /// <returns>分割した文字列の配列</returns>
        private string[] CountSplit(string value, int count)
        {
            var result = new List<string>();
            var length = (int)Math.Ceiling((double)value.Length / count);

            for (var index = 0; index < length; index++)
            {
                var start = count * index;

                if (value.Length <= start)
                {
                    break;
                }

                if (value.Length < start + count)
                {
                    result.Add(value.Substring(start));
                }
                else
                {
                    result.Add(value.Substring(start, count));
                }
            }

            return result.ToArray();
        }

        /// <summary>
        /// 日付(From)キーダウンイベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <remarks>
        /// エンターキー押下でエラーなしの場合、日付(To)へ
        /// 日付(To)が空白時、日付(From)の値を日付(To)へセット
        /// </remarks>
        private void txtPrintDateFrom_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                if(string.IsNullOrWhiteSpace(txtPrintDateTo.Text))
                {
                    txtPrintDateTo.Text = txtPrintDateFrom.Text;
                }

                txtPrintDateTo.Focus();
            }
        }

        /// <summary>
        /// 日付(To)キーダウンイベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void txtPrintDateTo_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                if(ErrorCheck())
                {
                    PrintCheckBox.Focus();
                }
            }
        }

        private void PrintCheckBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                this.btnClose.Focus();
            }
        }
    }
}
