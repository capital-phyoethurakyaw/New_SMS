﻿namespace SiharaiNyuuryoku
{
    partial class FrmSiharaiNyuuryoku
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle45 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle46 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle47 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle48 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle49 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle50 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle51 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle52 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle53 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle54 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle55 = new System.Windows.Forms.DataGridViewCellStyle();
            this.PanelDetail = new System.Windows.Forms.Panel();
            this.ckM_Label12 = new CKM_Controls.CKM_Label();
            this.dgvPayment = new CKM_Controls.CKM_GridView();
            this.colChk = new System.Windows.Forms.DataGridViewCheckBoxColumn();
            this.colPaymentDestination = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colPayeeName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colPaymentdueDate = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colScheduledPayment = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colAmountPaid = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colPaymenttime = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colTransferAmount = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colTransferFee = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colFeeBurden = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colOtherThanTransfer = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colUnpaidAmount = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ScStaff = new Search.CKM_SearchControl();
            this.txtPaymentDate = new CKM_Controls.CKM_TextBox();
            this.cboPaymentType = new CKM_Controls.CKM_ComboBox();
            this.ckM_Label7 = new CKM_Controls.CKM_Label();
            this.ckM_Label8 = new CKM_Controls.CKM_Label();
            this.ckM_Label9 = new CKM_Controls.CKM_Label();
            this.ckM_Label10 = new CKM_Controls.CKM_Label();
            this.cboPaymentSourceAcc = new CKM_Controls.CKM_ComboBox();
            this.btnReleaseAll = new CKM_Controls.CKM_Button();
            this.txtBillSettleDate = new CKM_Controls.CKM_TextBox();
            this.btnSelectAll = new CKM_Controls.CKM_Button();
            this.ckM_Label11 = new CKM_Controls.CKM_Label();
            this.ckmShop_Label2 = new CKM_Controls.CKMShop_Label();
            this.txtDueDate2 = new CKM_Controls.CKM_TextBox();
            this.txtDueDate1 = new CKM_Controls.CKM_TextBox();
            this.ckM_Label6 = new CKM_Controls.CKM_Label();
            this.ckM_Label5 = new CKM_Controls.CKM_Label();
            this.ckM_Label4 = new CKM_Controls.CKM_Label();
            this.ckM_Label3 = new CKM_Controls.CKM_Label();
            this.ckM_Label2 = new CKM_Controls.CKM_Label();
            this.ckM_Label1 = new CKM_Controls.CKM_Label();
            this.btnF10Show = new CKM_Controls.CKM_Button();
            this.ScPaymentNum = new Search.CKM_SearchControl();
            this.ScPaymentProcessNum = new Search.CKM_SearchControl();
            this.ScPayee = new Search.CKM_SearchControl();
            this.lblPayPlanGaku = new System.Windows.Forms.Label();
            this.lblPayConfirmGaku = new System.Windows.Forms.Label();
            this.lblPayGaku = new System.Windows.Forms.Label();
            this.lblTransferGaku = new System.Windows.Forms.Label();
            this.lblTransferFeeGaku = new System.Windows.Forms.Label();
            this.lblGakuTotal = new System.Windows.Forms.Label();
            this.lblPayPlan = new System.Windows.Forms.Label();
            this.PanelHeader.SuspendLayout();
            this.PanelDetail.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPayment)).BeginInit();
            this.SuspendLayout();
            // 
            // PanelHeader
            // 
            this.PanelHeader.Controls.Add(this.btnF10Show);
            this.PanelHeader.Controls.Add(this.ScPaymentNum);
            this.PanelHeader.Controls.Add(this.ckM_Label2);
            this.PanelHeader.Controls.Add(this.ScPaymentProcessNum);
            this.PanelHeader.Controls.Add(this.ckM_Label1);
            this.PanelHeader.Controls.Add(this.ScPayee);
            this.PanelHeader.Controls.Add(this.txtDueDate2);
            this.PanelHeader.Controls.Add(this.txtDueDate1);
            this.PanelHeader.Controls.Add(this.ckM_Label6);
            this.PanelHeader.Controls.Add(this.ckM_Label5);
            this.PanelHeader.Controls.Add(this.ckM_Label4);
            this.PanelHeader.Controls.Add(this.ckM_Label3);
            this.PanelHeader.Controls.Add(this.ckmShop_Label2);
            this.PanelHeader.Margin = new System.Windows.Forms.Padding(2);
            this.PanelHeader.Size = new System.Drawing.Size(1711, 174);
            this.PanelHeader.TabIndex = 0;
            this.PanelHeader.Controls.SetChildIndex(this.ckmShop_Label2, 0);
            this.PanelHeader.Controls.SetChildIndex(this.ckM_Label3, 0);
            this.PanelHeader.Controls.SetChildIndex(this.ckM_Label4, 0);
            this.PanelHeader.Controls.SetChildIndex(this.ckM_Label5, 0);
            this.PanelHeader.Controls.SetChildIndex(this.ckM_Label6, 0);
            this.PanelHeader.Controls.SetChildIndex(this.txtDueDate1, 0);
            this.PanelHeader.Controls.SetChildIndex(this.txtDueDate2, 0);
            this.PanelHeader.Controls.SetChildIndex(this.ScPayee, 0);
            this.PanelHeader.Controls.SetChildIndex(this.ckM_Label1, 0);
            this.PanelHeader.Controls.SetChildIndex(this.ScPaymentProcessNum, 0);
            this.PanelHeader.Controls.SetChildIndex(this.ckM_Label2, 0);
            this.PanelHeader.Controls.SetChildIndex(this.ScPaymentNum, 0);
            this.PanelHeader.Controls.SetChildIndex(this.btnF10Show, 0);
            // 
            // PanelSearch
            // 
            this.PanelSearch.Margin = new System.Windows.Forms.Padding(2);
            // 
            // PanelDetail
            // 
            this.PanelDetail.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(198)))), ((int)(((byte)(224)))), ((int)(((byte)(180)))));
            this.PanelDetail.Controls.Add(this.lblPayPlan);
            this.PanelDetail.Controls.Add(this.lblGakuTotal);
            this.PanelDetail.Controls.Add(this.lblTransferFeeGaku);
            this.PanelDetail.Controls.Add(this.lblTransferGaku);
            this.PanelDetail.Controls.Add(this.lblPayGaku);
            this.PanelDetail.Controls.Add(this.lblPayConfirmGaku);
            this.PanelDetail.Controls.Add(this.lblPayPlanGaku);
            this.PanelDetail.Controls.Add(this.ckM_Label12);
            this.PanelDetail.Controls.Add(this.dgvPayment);
            this.PanelDetail.Controls.Add(this.ScStaff);
            this.PanelDetail.Controls.Add(this.txtPaymentDate);
            this.PanelDetail.Controls.Add(this.cboPaymentType);
            this.PanelDetail.Controls.Add(this.ckM_Label7);
            this.PanelDetail.Controls.Add(this.ckM_Label8);
            this.PanelDetail.Controls.Add(this.ckM_Label9);
            this.PanelDetail.Controls.Add(this.ckM_Label10);
            this.PanelDetail.Controls.Add(this.cboPaymentSourceAcc);
            this.PanelDetail.Controls.Add(this.btnReleaseAll);
            this.PanelDetail.Controls.Add(this.txtBillSettleDate);
            this.PanelDetail.Controls.Add(this.btnSelectAll);
            this.PanelDetail.Controls.Add(this.ckM_Label11);
            this.PanelDetail.Dock = System.Windows.Forms.DockStyle.Fill;
            this.PanelDetail.Location = new System.Drawing.Point(0, 230);
            this.PanelDetail.Margin = new System.Windows.Forms.Padding(2);
            this.PanelDetail.Name = "PanelDetail";
            this.PanelDetail.Size = new System.Drawing.Size(1713, 549);
            this.PanelDetail.TabIndex = 0;
            // 
            // ckM_Label12
            // 
            this.ckM_Label12.AutoSize = true;
            this.ckM_Label12.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label12.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label12.DefaultlabelSize = true;
            this.ckM_Label12.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label12.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label12.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label12.Location = new System.Drawing.Point(489, 455);
            this.ckM_Label12.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.ckM_Label12.Name = "ckM_Label12";
            this.ckM_Label12.Size = new System.Drawing.Size(31, 12);
            this.ckM_Label12.TabIndex = 50;
            this.ckM_Label12.Text = "合計";
            this.ckM_Label12.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label12.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // dgvPayment
            // 
            this.dgvPayment.AllowUserToAddRows = false;
            this.dgvPayment.AllowUserToDeleteRows = false;
            this.dgvPayment.AllowUserToResizeRows = false;
            dataGridViewCellStyle45.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(221)))), ((int)(((byte)(235)))), ((int)(((byte)(247)))));
            this.dgvPayment.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle45;
            this.dgvPayment.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(198)))), ((int)(((byte)(224)))), ((int)(((byte)(180)))));
            dataGridViewCellStyle46.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle46.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            dataGridViewCellStyle46.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold);
            dataGridViewCellStyle46.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle46.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle46.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle46.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvPayment.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle46;
            this.dgvPayment.ColumnHeadersHeight = 25;
            this.dgvPayment.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.colChk,
            this.colPaymentDestination,
            this.colPayeeName,
            this.colPaymentdueDate,
            this.colScheduledPayment,
            this.colAmountPaid,
            this.colPaymenttime,
            this.colTransferAmount,
            this.colTransferFee,
            this.colFeeBurden,
            this.colOtherThanTransfer,
            this.colUnpaidAmount});
            this.dgvPayment.EnableHeadersVisualStyles = false;
            this.dgvPayment.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(198)))), ((int)(((byte)(224)))), ((int)(((byte)(180)))));
            this.dgvPayment.Location = new System.Drawing.Point(35, 87);
            this.dgvPayment.Margin = new System.Windows.Forms.Padding(2);
            this.dgvPayment.Name = "dgvPayment";
            this.dgvPayment.Size = new System.Drawing.Size(1500, 350);
            this.dgvPayment.TabIndex = 7;
            this.dgvPayment.UseRowNo = true;
            this.dgvPayment.UseSetting = true;
            // 
            // colChk
            // 
            this.colChk.HeaderText = "";
            this.colChk.Name = "colChk";
            this.colChk.Width = 40;
            // 
            // colPaymentDestination
            // 
            this.colPaymentDestination.DataPropertyName = "PayeeCD";
            this.colPaymentDestination.HeaderText = "支払先";
            this.colPaymentDestination.Name = "colPaymentDestination";
            this.colPaymentDestination.Width = 110;
            // 
            // colPayeeName
            // 
            this.colPayeeName.DataPropertyName = "VendorName";
            this.colPayeeName.HeaderText = "支払先名";
            this.colPayeeName.Name = "colPayeeName";
            this.colPayeeName.Width = 200;
            // 
            // colPaymentdueDate
            // 
            this.colPaymentdueDate.DataPropertyName = "PayPlanDate";
            dataGridViewCellStyle47.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            this.colPaymentdueDate.DefaultCellStyle = dataGridViewCellStyle47;
            this.colPaymentdueDate.HeaderText = "支払予定日";
            this.colPaymentdueDate.MaxInputLength = 10;
            this.colPaymentdueDate.Name = "colPaymentdueDate";
            this.colPaymentdueDate.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.colPaymentdueDate.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            // 
            // colScheduledPayment
            // 
            this.colScheduledPayment.DataPropertyName = "PayPlanGaku";
            dataGridViewCellStyle48.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            this.colScheduledPayment.DefaultCellStyle = dataGridViewCellStyle48;
            this.colScheduledPayment.HeaderText = "支払予定額";
            this.colScheduledPayment.MaxInputLength = 6;
            this.colScheduledPayment.Name = "colScheduledPayment";
            // 
            // colAmountPaid
            // 
            this.colAmountPaid.DataPropertyName = "PayConfirmGaku";
            dataGridViewCellStyle49.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            this.colAmountPaid.DefaultCellStyle = dataGridViewCellStyle49;
            this.colAmountPaid.HeaderText = "支払済額";
            this.colAmountPaid.MaxInputLength = 6;
            this.colAmountPaid.Name = "colAmountPaid";
            // 
            // colPaymenttime
            // 
            this.colPaymenttime.DataPropertyName = "PayGaku";
            dataGridViewCellStyle50.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            this.colPaymenttime.DefaultCellStyle = dataGridViewCellStyle50;
            this.colPaymenttime.HeaderText = "今回支払額";
            this.colPaymenttime.MaxInputLength = 6;
            this.colPaymenttime.Name = "colPaymenttime";
            // 
            // colTransferAmount
            // 
            this.colTransferAmount.DataPropertyName = "TransferGaku";
            dataGridViewCellStyle51.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            this.colTransferAmount.DefaultCellStyle = dataGridViewCellStyle51;
            this.colTransferAmount.HeaderText = "振込額";
            this.colTransferAmount.MaxInputLength = 6;
            this.colTransferAmount.Name = "colTransferAmount";
            // 
            // colTransferFee
            // 
            this.colTransferFee.DataPropertyName = "TransferFeeGaku";
            dataGridViewCellStyle52.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            this.colTransferFee.DefaultCellStyle = dataGridViewCellStyle52;
            this.colTransferFee.HeaderText = "振込手数料";
            this.colTransferFee.MaxInputLength = 6;
            this.colTransferFee.Name = "colTransferFee";
            // 
            // colFeeBurden
            // 
            this.colFeeBurden.DataPropertyName = "FeeKBN";
            dataGridViewCellStyle53.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            this.colFeeBurden.DefaultCellStyle = dataGridViewCellStyle53;
            this.colFeeBurden.HeaderText = "手数料負担";
            this.colFeeBurden.MaxInputLength = 4;
            this.colFeeBurden.Name = "colFeeBurden";
            // 
            // colOtherThanTransfer
            // 
            this.colOtherThanTransfer.DataPropertyName = "Gaku";
            dataGridViewCellStyle54.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            this.colOtherThanTransfer.DefaultCellStyle = dataGridViewCellStyle54;
            this.colOtherThanTransfer.HeaderText = "振込以外";
            this.colOtherThanTransfer.MaxInputLength = 6;
            this.colOtherThanTransfer.Name = "colOtherThanTransfer";
            // 
            // colUnpaidAmount
            // 
            this.colUnpaidAmount.DataPropertyName = "PayPlan";
            dataGridViewCellStyle55.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            this.colUnpaidAmount.DefaultCellStyle = dataGridViewCellStyle55;
            this.colUnpaidAmount.HeaderText = "未支払額";
            this.colUnpaidAmount.MaxInputLength = 6;
            this.colUnpaidAmount.Name = "colUnpaidAmount";
            // 
            // ScStaff
            // 
            this.ScStaff.AutoSize = true;
            this.ScStaff.ChangeDate = "";
            this.ScStaff.ChangeDateWidth = 3949;
            this.ScStaff.Code = "";
            this.ScStaff.CodeWidth = 100;
            this.ScStaff.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.ScStaff.DataCheck = false;
            this.ScStaff.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.ScStaff.IsCopy = false;
            this.ScStaff.LabelText = "";
            this.ScStaff.LabelVisible = true;
            this.ScStaff.Location = new System.Drawing.Point(1353, 2);
            this.ScStaff.Margin = new System.Windows.Forms.Padding(0);
            this.ScStaff.Name = "ScStaff";
            this.ScStaff.SearchEnable = true;
            this.ScStaff.Size = new System.Drawing.Size(344, 27);
            this.ScStaff.Stype = Search.CKM_SearchControl.SearchType.スタッフ;
            this.ScStaff.TabIndex = 1;
            this.ScStaff.TextSize = Search.CKM_SearchControl.FontSize.Normal;
            this.ScStaff.UseChangeDate = false;
            this.ScStaff.Value1 = null;
            this.ScStaff.Value2 = null;
            this.ScStaff.Value3 = null;
            // 
            // txtPaymentDate
            // 
            this.txtPaymentDate.AllowMinus = false;
            this.txtPaymentDate.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.txtPaymentDate.BackColor = System.Drawing.Color.White;
            this.txtPaymentDate.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtPaymentDate.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.txtPaymentDate.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Date;
            this.txtPaymentDate.DecimalPlace = 0;
            this.txtPaymentDate.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.txtPaymentDate.IntegerPart = 0;
            this.txtPaymentDate.IsCorrectDate = true;
            this.txtPaymentDate.isEnterKeyDown = false;
            this.txtPaymentDate.IsNumber = true;
            this.txtPaymentDate.IsShop = false;
            this.txtPaymentDate.Length = 10;
            this.txtPaymentDate.Location = new System.Drawing.Point(131, 14);
            this.txtPaymentDate.Margin = new System.Windows.Forms.Padding(2);
            this.txtPaymentDate.MaxLength = 10;
            this.txtPaymentDate.MoveNext = true;
            this.txtPaymentDate.Name = "txtPaymentDate";
            this.txtPaymentDate.Size = new System.Drawing.Size(76, 19);
            this.txtPaymentDate.TabIndex = 0;
            this.txtPaymentDate.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtPaymentDate.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            // 
            // cboPaymentType
            // 
            this.cboPaymentType.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Append;
            this.cboPaymentType.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.cboPaymentType.Cbo_Type = CKM_Controls.CKM_ComboBox.CboType.支払金種;
            this.cboPaymentType.Ctrl_Byte = CKM_Controls.CKM_ComboBox.Bytes.半全角;
            this.cboPaymentType.FormattingEnabled = true;
            this.cboPaymentType.Length = 10;
            this.cboPaymentType.Location = new System.Drawing.Point(131, 48);
            this.cboPaymentType.Margin = new System.Windows.Forms.Padding(2);
            this.cboPaymentType.MaxLength = 5;
            this.cboPaymentType.MoveNext = true;
            this.cboPaymentType.Name = "cboPaymentType";
            this.cboPaymentType.Size = new System.Drawing.Size(114, 20);
            this.cboPaymentType.TabIndex = 2;
            // 
            // ckM_Label7
            // 
            this.ckM_Label7.AutoSize = true;
            this.ckM_Label7.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label7.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label7.DefaultlabelSize = true;
            this.ckM_Label7.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label7.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label7.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label7.Location = new System.Drawing.Point(86, 17);
            this.ckM_Label7.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.ckM_Label7.Name = "ckM_Label7";
            this.ckM_Label7.Size = new System.Drawing.Size(44, 12);
            this.ckM_Label7.TabIndex = 40;
            this.ckM_Label7.Text = "支払日";
            this.ckM_Label7.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label7.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label8
            // 
            this.ckM_Label8.AutoSize = true;
            this.ckM_Label8.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label8.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label8.DefaultlabelSize = true;
            this.ckM_Label8.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label8.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label8.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label8.Location = new System.Drawing.Point(73, 51);
            this.ckM_Label8.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.ckM_Label8.Name = "ckM_Label8";
            this.ckM_Label8.Size = new System.Drawing.Size(57, 12);
            this.ckM_Label8.TabIndex = 41;
            this.ckM_Label8.Text = "支払金種";
            this.ckM_Label8.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label8.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label9
            // 
            this.ckM_Label9.AutoSize = true;
            this.ckM_Label9.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label9.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label9.DefaultlabelSize = true;
            this.ckM_Label9.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label9.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label9.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label9.Location = new System.Drawing.Point(284, 50);
            this.ckM_Label9.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.ckM_Label9.Name = "ckM_Label9";
            this.ckM_Label9.Size = new System.Drawing.Size(70, 12);
            this.ckM_Label9.TabIndex = 42;
            this.ckM_Label9.Text = "支払元口座";
            this.ckM_Label9.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label9.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label10
            // 
            this.ckM_Label10.AutoSize = true;
            this.ckM_Label10.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label10.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label10.DefaultlabelSize = true;
            this.ckM_Label10.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label10.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label10.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label10.Location = new System.Drawing.Point(518, 50);
            this.ckM_Label10.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.ckM_Label10.Name = "ckM_Label10";
            this.ckM_Label10.Size = new System.Drawing.Size(70, 12);
            this.ckM_Label10.TabIndex = 43;
            this.ckM_Label10.Text = "手形決済日";
            this.ckM_Label10.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label10.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // cboPaymentSourceAcc
            // 
            this.cboPaymentSourceAcc.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.Append;
            this.cboPaymentSourceAcc.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.ListItems;
            this.cboPaymentSourceAcc.Cbo_Type = CKM_Controls.CKM_ComboBox.CboType.銀行口座;
            this.cboPaymentSourceAcc.Ctrl_Byte = CKM_Controls.CKM_ComboBox.Bytes.半全角;
            this.cboPaymentSourceAcc.FormattingEnabled = true;
            this.cboPaymentSourceAcc.Length = 10;
            this.cboPaymentSourceAcc.Location = new System.Drawing.Point(355, 47);
            this.cboPaymentSourceAcc.Margin = new System.Windows.Forms.Padding(2);
            this.cboPaymentSourceAcc.MaxLength = 5;
            this.cboPaymentSourceAcc.MoveNext = true;
            this.cboPaymentSourceAcc.Name = "cboPaymentSourceAcc";
            this.cboPaymentSourceAcc.Size = new System.Drawing.Size(114, 20);
            this.cboPaymentSourceAcc.TabIndex = 3;
            // 
            // btnReleaseAll
            // 
            this.btnReleaseAll.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.btnReleaseAll.BackgroundColor = CKM_Controls.CKM_Button.CKM_Color.Default;
            this.btnReleaseAll.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnReleaseAll.DefaultBtnSize = false;
            this.btnReleaseAll.FlatAppearance.BorderColor = System.Drawing.Color.Black;
            this.btnReleaseAll.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnReleaseAll.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.btnReleaseAll.Font_Size = CKM_Controls.CKM_Button.CKM_FontSize.Normal;
            this.btnReleaseAll.Location = new System.Drawing.Point(1606, 34);
            this.btnReleaseAll.Margin = new System.Windows.Forms.Padding(1);
            this.btnReleaseAll.Name = "btnReleaseAll";
            this.btnReleaseAll.Size = new System.Drawing.Size(88, 22);
            this.btnReleaseAll.TabIndex = 6;
            this.btnReleaseAll.Text = "全解除";
            this.btnReleaseAll.UseVisualStyleBackColor = false;
            this.btnReleaseAll.Click += new System.EventHandler(this.btnReleaseAll_Click);
            // 
            // txtBillSettleDate
            // 
            this.txtBillSettleDate.AllowMinus = false;
            this.txtBillSettleDate.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.txtBillSettleDate.BackColor = System.Drawing.Color.White;
            this.txtBillSettleDate.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtBillSettleDate.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.txtBillSettleDate.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Date;
            this.txtBillSettleDate.DecimalPlace = 0;
            this.txtBillSettleDate.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.txtBillSettleDate.IntegerPart = 0;
            this.txtBillSettleDate.IsCorrectDate = true;
            this.txtBillSettleDate.isEnterKeyDown = false;
            this.txtBillSettleDate.IsNumber = true;
            this.txtBillSettleDate.IsShop = false;
            this.txtBillSettleDate.Length = 10;
            this.txtBillSettleDate.Location = new System.Drawing.Point(588, 48);
            this.txtBillSettleDate.Margin = new System.Windows.Forms.Padding(2);
            this.txtBillSettleDate.MaxLength = 10;
            this.txtBillSettleDate.MoveNext = true;
            this.txtBillSettleDate.Name = "txtBillSettleDate";
            this.txtBillSettleDate.Size = new System.Drawing.Size(76, 19);
            this.txtBillSettleDate.TabIndex = 4;
            this.txtBillSettleDate.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtBillSettleDate.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            // 
            // btnSelectAll
            // 
            this.btnSelectAll.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.btnSelectAll.BackgroundColor = CKM_Controls.CKM_Button.CKM_Color.Default;
            this.btnSelectAll.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnSelectAll.DefaultBtnSize = false;
            this.btnSelectAll.FlatAppearance.BorderColor = System.Drawing.Color.Black;
            this.btnSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnSelectAll.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.btnSelectAll.Font_Size = CKM_Controls.CKM_Button.CKM_FontSize.Normal;
            this.btnSelectAll.Location = new System.Drawing.Point(1518, 34);
            this.btnSelectAll.Margin = new System.Windows.Forms.Padding(1);
            this.btnSelectAll.Name = "btnSelectAll";
            this.btnSelectAll.Size = new System.Drawing.Size(88, 22);
            this.btnSelectAll.TabIndex = 5;
            this.btnSelectAll.Text = "全選択";
            this.btnSelectAll.UseVisualStyleBackColor = false;
            this.btnSelectAll.Click += new System.EventHandler(this.btnSelectAll_Click);
            // 
            // ckM_Label11
            // 
            this.ckM_Label11.AutoSize = true;
            this.ckM_Label11.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label11.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label11.DefaultlabelSize = true;
            this.ckM_Label11.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label11.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label11.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label11.Location = new System.Drawing.Point(1269, 10);
            this.ckM_Label11.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.ckM_Label11.Name = "ckM_Label11";
            this.ckM_Label11.Size = new System.Drawing.Size(83, 12);
            this.ckM_Label11.TabIndex = 46;
            this.ckM_Label11.Text = "担当スタッフ";
            this.ckM_Label11.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label11.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckmShop_Label2
            // 
            this.ckmShop_Label2.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.ckmShop_Label2.BackColor = System.Drawing.Color.Black;
            this.ckmShop_Label2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.ckmShop_Label2.Font = new System.Drawing.Font("MS Gothic", 18F, System.Drawing.FontStyle.Bold);
            this.ckmShop_Label2.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.ckmShop_Label2.ForeColor = System.Drawing.Color.Black;
            this.ckmShop_Label2.Location = new System.Drawing.Point(1, 56);
            this.ckmShop_Label2.Name = "ckmShop_Label2";
            this.ckmShop_Label2.Size = new System.Drawing.Size(1729, 2);
            this.ckmShop_Label2.TabIndex = 2;
            this.ckmShop_Label2.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.ckmShop_Label2.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // txtDueDate2
            // 
            this.txtDueDate2.AllowMinus = false;
            this.txtDueDate2.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.txtDueDate2.BackColor = System.Drawing.Color.White;
            this.txtDueDate2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtDueDate2.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.txtDueDate2.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Date;
            this.txtDueDate2.DecimalPlace = 0;
            this.txtDueDate2.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.txtDueDate2.IntegerPart = 0;
            this.txtDueDate2.IsCorrectDate = true;
            this.txtDueDate2.isEnterKeyDown = false;
            this.txtDueDate2.IsNumber = true;
            this.txtDueDate2.IsShop = false;
            this.txtDueDate2.Length = 10;
            this.txtDueDate2.Location = new System.Drawing.Point(274, 84);
            this.txtDueDate2.MaxLength = 10;
            this.txtDueDate2.MoveNext = true;
            this.txtDueDate2.Name = "txtDueDate2";
            this.txtDueDate2.Size = new System.Drawing.Size(116, 19);
            this.txtDueDate2.TabIndex = 4;
            this.txtDueDate2.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtDueDate2.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            // 
            // txtDueDate1
            // 
            this.txtDueDate1.AllowMinus = false;
            this.txtDueDate1.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.White;
            this.txtDueDate1.BackColor = System.Drawing.Color.White;
            this.txtDueDate1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtDueDate1.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.txtDueDate1.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Date;
            this.txtDueDate1.DecimalPlace = 0;
            this.txtDueDate1.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.txtDueDate1.IntegerPart = 0;
            this.txtDueDate1.IsCorrectDate = true;
            this.txtDueDate1.isEnterKeyDown = false;
            this.txtDueDate1.IsNumber = true;
            this.txtDueDate1.IsShop = false;
            this.txtDueDate1.Length = 10;
            this.txtDueDate1.Location = new System.Drawing.Point(130, 84);
            this.txtDueDate1.MaxLength = 10;
            this.txtDueDate1.MoveNext = true;
            this.txtDueDate1.Name = "txtDueDate1";
            this.txtDueDate1.Size = new System.Drawing.Size(116, 19);
            this.txtDueDate1.TabIndex = 3;
            this.txtDueDate1.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            this.txtDueDate1.TextSize = CKM_Controls.CKM_TextBox.FontSize.Normal;
            // 
            // ckM_Label6
            // 
            this.ckM_Label6.AutoSize = true;
            this.ckM_Label6.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label6.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label6.DefaultlabelSize = true;
            this.ckM_Label6.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label6.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label6.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label6.Location = new System.Drawing.Point(83, 114);
            this.ckM_Label6.Name = "ckM_Label6";
            this.ckM_Label6.Size = new System.Drawing.Size(44, 12);
            this.ckM_Label6.TabIndex = 47;
            this.ckM_Label6.Text = "支払先";
            this.ckM_Label6.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label6.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label5
            // 
            this.ckM_Label5.AutoSize = true;
            this.ckM_Label5.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label5.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label5.DefaultlabelSize = true;
            this.ckM_Label5.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label5.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label5.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label5.Location = new System.Drawing.Point(250, 89);
            this.ckM_Label5.Name = "ckM_Label5";
            this.ckM_Label5.Size = new System.Drawing.Size(18, 12);
            this.ckM_Label5.TabIndex = 46;
            this.ckM_Label5.Text = "～";
            this.ckM_Label5.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label5.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label4
            // 
            this.ckM_Label4.AutoSize = true;
            this.ckM_Label4.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label4.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label4.DefaultlabelSize = true;
            this.ckM_Label4.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label4.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label4.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label4.Location = new System.Drawing.Point(57, 88);
            this.ckM_Label4.Name = "ckM_Label4";
            this.ckM_Label4.Size = new System.Drawing.Size(70, 12);
            this.ckM_Label4.TabIndex = 45;
            this.ckM_Label4.Text = "支払予定日";
            this.ckM_Label4.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label4.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label3
            // 
            this.ckM_Label3.AutoSize = true;
            this.ckM_Label3.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label3.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label3.DefaultlabelSize = true;
            this.ckM_Label3.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label3.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label3.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label3.Location = new System.Drawing.Point(45, 69);
            this.ckM_Label3.Name = "ckM_Label3";
            this.ckM_Label3.Size = new System.Drawing.Size(83, 12);
            this.ckM_Label3.TabIndex = 44;
            this.ckM_Label3.Text = "【抽出条件】";
            this.ckM_Label3.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label3.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label2
            // 
            this.ckM_Label2.AutoSize = true;
            this.ckM_Label2.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label2.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label2.DefaultlabelSize = true;
            this.ckM_Label2.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label2.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label2.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label2.Location = new System.Drawing.Point(370, 21);
            this.ckM_Label2.Name = "ckM_Label2";
            this.ckM_Label2.Size = new System.Drawing.Size(57, 12);
            this.ckM_Label2.TabIndex = 51;
            this.ckM_Label2.Text = "支払番号";
            this.ckM_Label2.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label2.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // ckM_Label1
            // 
            this.ckM_Label1.AutoSize = true;
            this.ckM_Label1.Back_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label1.BackColor = System.Drawing.Color.Transparent;
            this.ckM_Label1.DefaultlabelSize = true;
            this.ckM_Label1.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.ckM_Label1.Font_Size = CKM_Controls.CKM_Label.CKM_FontSize.Normal;
            this.ckM_Label1.ForeColor = System.Drawing.Color.Black;
            this.ckM_Label1.Location = new System.Drawing.Point(45, 21);
            this.ckM_Label1.Name = "ckM_Label1";
            this.ckM_Label1.Size = new System.Drawing.Size(83, 12);
            this.ckM_Label1.TabIndex = 50;
            this.ckM_Label1.Text = "支払処理番号";
            this.ckM_Label1.Text_Color = CKM_Controls.CKM_Label.CKM_Color.Default;
            this.ckM_Label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // btnF10Show
            // 
            this.btnF10Show.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            this.btnF10Show.BackgroundColor = CKM_Controls.CKM_Button.CKM_Color.Default;
            this.btnF10Show.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnF10Show.DefaultBtnSize = false;
            this.btnF10Show.FlatAppearance.BorderColor = System.Drawing.Color.Black;
            this.btnF10Show.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnF10Show.Font = new System.Drawing.Font("MS Gothic", 9F, System.Drawing.FontStyle.Bold);
            this.btnF10Show.Font_Size = CKM_Controls.CKM_Button.CKM_FontSize.Normal;
            this.btnF10Show.Location = new System.Drawing.Point(1603, 113);
            this.btnF10Show.Margin = new System.Windows.Forms.Padding(1);
            this.btnF10Show.Name = "btnF10Show";
            this.btnF10Show.Size = new System.Drawing.Size(88, 22);
            this.btnF10Show.TabIndex = 6;
            this.btnF10Show.Text = "表示(F10)";
            this.btnF10Show.UseVisualStyleBackColor = false;
            // 
            // ScPaymentNum
            // 
            this.ScPaymentNum.AutoSize = true;
            this.ScPaymentNum.ChangeDate = "";
            this.ScPaymentNum.ChangeDateWidth = 3949;
            this.ScPaymentNum.Code = "";
            this.ScPaymentNum.CodeWidth = 110;
            this.ScPaymentNum.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.ScPaymentNum.DataCheck = false;
            this.ScPaymentNum.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.ScPaymentNum.IsCopy = false;
            this.ScPaymentNum.LabelText = "";
            this.ScPaymentNum.LabelVisible = false;
            this.ScPaymentNum.Location = new System.Drawing.Point(429, 13);
            this.ScPaymentNum.Margin = new System.Windows.Forms.Padding(0);
            this.ScPaymentNum.Name = "ScPaymentNum";
            this.ScPaymentNum.SearchEnable = true;
            this.ScPaymentNum.Size = new System.Drawing.Size(143, 32);
            this.ScPaymentNum.Stype = Search.CKM_SearchControl.SearchType.支払処理;
            this.ScPaymentNum.TabIndex = 1;
            this.ScPaymentNum.TextSize = Search.CKM_SearchControl.FontSize.Normal;
            this.ScPaymentNum.UseChangeDate = false;
            this.ScPaymentNum.Value1 = null;
            this.ScPaymentNum.Value2 = null;
            this.ScPaymentNum.Value3 = null;
            this.ScPaymentNum.CodeKeyDownEvent += new Search.CKM_SearchControl.KeyEventHandler(this.ScPaymentNum_CodeKeyDownEvent);
            // 
            // ScPaymentProcessNum
            // 
            this.ScPaymentProcessNum.AutoSize = true;
            this.ScPaymentProcessNum.ChangeDate = "";
            this.ScPaymentProcessNum.ChangeDateWidth = 3949;
            this.ScPaymentProcessNum.Code = "";
            this.ScPaymentProcessNum.CodeWidth = 110;
            this.ScPaymentProcessNum.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.ScPaymentProcessNum.DataCheck = false;
            this.ScPaymentProcessNum.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.ScPaymentProcessNum.IsCopy = false;
            this.ScPaymentProcessNum.LabelText = "";
            this.ScPaymentProcessNum.LabelVisible = false;
            this.ScPaymentProcessNum.Location = new System.Drawing.Point(130, 13);
            this.ScPaymentProcessNum.Margin = new System.Windows.Forms.Padding(0);
            this.ScPaymentProcessNum.Name = "ScPaymentProcessNum";
            this.ScPaymentProcessNum.SearchEnable = true;
            this.ScPaymentProcessNum.Size = new System.Drawing.Size(143, 32);
            this.ScPaymentProcessNum.Stype = Search.CKM_SearchControl.SearchType.支払処理;
            this.ScPaymentProcessNum.TabIndex = 0;
            this.ScPaymentProcessNum.TextSize = Search.CKM_SearchControl.FontSize.Normal;
            this.ScPaymentProcessNum.UseChangeDate = false;
            this.ScPaymentProcessNum.Value1 = null;
            this.ScPaymentProcessNum.Value2 = null;
            this.ScPaymentProcessNum.Value3 = null;
            this.ScPaymentProcessNum.CodeKeyDownEvent += new Search.CKM_SearchControl.KeyEventHandler(this.ScPaymentProcessNum_CodeKeyDownEvent);
            // 
            // ScPayee
            // 
            this.ScPayee.AutoSize = true;
            this.ScPayee.ChangeDate = "";
            this.ScPayee.ChangeDateWidth = 4607;
            this.ScPayee.Code = "";
            this.ScPayee.CodeWidth = 130;
            this.ScPayee.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.ScPayee.DataCheck = false;
            this.ScPayee.Font = new System.Drawing.Font("MS Gothic", 9F);
            this.ScPayee.IsCopy = false;
            this.ScPayee.LabelText = "";
            this.ScPayee.LabelVisible = true;
            this.ScPayee.Location = new System.Drawing.Point(130, 105);
            this.ScPayee.Margin = new System.Windows.Forms.Padding(0);
            this.ScPayee.Name = "ScPayee";
            this.ScPayee.SearchEnable = true;
            this.ScPayee.Size = new System.Drawing.Size(444, 32);
            this.ScPayee.Stype = Search.CKM_SearchControl.SearchType.仕入先;
            this.ScPayee.TabIndex = 5;
            this.ScPayee.TextSize = Search.CKM_SearchControl.FontSize.Normal;
            this.ScPayee.UseChangeDate = false;
            this.ScPayee.Value1 = null;
            this.ScPayee.Value2 = null;
            this.ScPayee.Value3 = null;
            // 
            // lblPayPlanGaku
            // 
            this.lblPayPlanGaku.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(169)))), ((int)(((byte)(208)))), ((int)(((byte)(142)))));
            this.lblPayPlanGaku.Location = new System.Drawing.Point(523, 452);
            this.lblPayPlanGaku.Name = "lblPayPlanGaku";
            this.lblPayPlanGaku.Size = new System.Drawing.Size(100, 19);
            this.lblPayPlanGaku.TabIndex = 101;
            this.lblPayPlanGaku.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblPayConfirmGaku
            // 
            this.lblPayConfirmGaku.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(169)))), ((int)(((byte)(208)))), ((int)(((byte)(142)))));
            this.lblPayConfirmGaku.Location = new System.Drawing.Point(624, 452);
            this.lblPayConfirmGaku.Name = "lblPayConfirmGaku";
            this.lblPayConfirmGaku.Size = new System.Drawing.Size(100, 19);
            this.lblPayConfirmGaku.TabIndex = 102;
            this.lblPayConfirmGaku.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblPayGaku
            // 
            this.lblPayGaku.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(169)))), ((int)(((byte)(208)))), ((int)(((byte)(142)))));
            this.lblPayGaku.Location = new System.Drawing.Point(725, 452);
            this.lblPayGaku.Name = "lblPayGaku";
            this.lblPayGaku.Size = new System.Drawing.Size(100, 19);
            this.lblPayGaku.TabIndex = 103;
            this.lblPayGaku.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblTransferGaku
            // 
            this.lblTransferGaku.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(169)))), ((int)(((byte)(208)))), ((int)(((byte)(142)))));
            this.lblTransferGaku.Location = new System.Drawing.Point(826, 452);
            this.lblTransferGaku.Name = "lblTransferGaku";
            this.lblTransferGaku.Size = new System.Drawing.Size(100, 19);
            this.lblTransferGaku.TabIndex = 104;
            this.lblTransferGaku.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblTransferFeeGaku
            // 
            this.lblTransferFeeGaku.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(169)))), ((int)(((byte)(208)))), ((int)(((byte)(142)))));
            this.lblTransferFeeGaku.Location = new System.Drawing.Point(927, 452);
            this.lblTransferFeeGaku.Name = "lblTransferFeeGaku";
            this.lblTransferFeeGaku.Size = new System.Drawing.Size(100, 19);
            this.lblTransferFeeGaku.TabIndex = 105;
            this.lblTransferFeeGaku.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblGakuTotal
            // 
            this.lblGakuTotal.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(169)))), ((int)(((byte)(208)))), ((int)(((byte)(142)))));
            this.lblGakuTotal.Location = new System.Drawing.Point(1131, 452);
            this.lblGakuTotal.Name = "lblGakuTotal";
            this.lblGakuTotal.Size = new System.Drawing.Size(100, 19);
            this.lblGakuTotal.TabIndex = 106;
            this.lblGakuTotal.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblPayPlan
            // 
            this.lblPayPlan.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(169)))), ((int)(((byte)(208)))), ((int)(((byte)(142)))));
            this.lblPayPlan.Location = new System.Drawing.Point(1232, 452);
            this.lblPayPlan.Name = "lblPayPlan";
            this.lblPayPlan.Size = new System.Drawing.Size(100, 19);
            this.lblPayPlan.TabIndex = 107;
            this.lblPayPlan.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // FrmSiharaiNyuuryoku
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1713, 811);
            this.Controls.Add(this.PanelDetail);
            this.Location = new System.Drawing.Point(0, 0);
            this.Margin = new System.Windows.Forms.Padding(2);
            this.ModeVisible = true;
            this.Name = "FrmSiharaiNyuuryoku";
            this.PanelHeaderHeight = 230;
            this.Text = "SiharaiNyuuryoku";
            this.Load += new System.EventHandler(this.FrmSiharaiNyuuryoku_Load);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.FrmSiharaiNyuuryoku_KeyUp);
            this.Controls.SetChildIndex(this.PanelDetail, 0);
            this.PanelHeader.ResumeLayout(false);
            this.PanelHeader.PerformLayout();
            this.PanelDetail.ResumeLayout(false);
            this.PanelDetail.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPayment)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Search.CKM_SearchControl ScPaymentNum;
        private CKM_Controls.CKM_Label ckM_Label2;
        private Search.CKM_SearchControl ScPaymentProcessNum;
        private CKM_Controls.CKM_Label ckM_Label1;
        private Search.CKM_SearchControl ScPayee;
        private CKM_Controls.CKM_TextBox txtDueDate2;
        private CKM_Controls.CKM_TextBox txtDueDate1;
        private CKM_Controls.CKM_Label ckM_Label6;
        private CKM_Controls.CKM_Label ckM_Label5;
        private CKM_Controls.CKM_Label ckM_Label4;
        private CKM_Controls.CKM_Label ckM_Label3;
        private CKM_Controls.CKMShop_Label ckmShop_Label2;
        private System.Windows.Forms.Panel PanelDetail;
        private Search.CKM_SearchControl ScStaff;
        private CKM_Controls.CKM_TextBox txtPaymentDate;
        private CKM_Controls.CKM_ComboBox cboPaymentType;
        private CKM_Controls.CKM_Label ckM_Label7;
        private CKM_Controls.CKM_Label ckM_Label8;
        private CKM_Controls.CKM_Label ckM_Label9;
        private CKM_Controls.CKM_Label ckM_Label10;
        private CKM_Controls.CKM_ComboBox cboPaymentSourceAcc;
        private CKM_Controls.CKM_Button btnReleaseAll;
        private CKM_Controls.CKM_TextBox txtBillSettleDate;
        private CKM_Controls.CKM_Button btnSelectAll;
        private CKM_Controls.CKM_Label ckM_Label11;
        private CKM_Controls.CKM_Label ckM_Label12;
        private CKM_Controls.CKM_GridView dgvPayment;
        private CKM_Controls.CKM_Button btnF10Show;
        private System.Windows.Forms.DataGridViewCheckBoxColumn colChk;
        private System.Windows.Forms.DataGridViewTextBoxColumn colPaymentDestination;
        private System.Windows.Forms.DataGridViewTextBoxColumn colPayeeName;
        private System.Windows.Forms.DataGridViewTextBoxColumn colPaymentdueDate;
        private System.Windows.Forms.DataGridViewTextBoxColumn colScheduledPayment;
        private System.Windows.Forms.DataGridViewTextBoxColumn colAmountPaid;
        private System.Windows.Forms.DataGridViewTextBoxColumn colPaymenttime;
        private System.Windows.Forms.DataGridViewTextBoxColumn colTransferAmount;
        private System.Windows.Forms.DataGridViewTextBoxColumn colTransferFee;
        private System.Windows.Forms.DataGridViewTextBoxColumn colFeeBurden;
        private System.Windows.Forms.DataGridViewTextBoxColumn colOtherThanTransfer;
        private System.Windows.Forms.DataGridViewTextBoxColumn colUnpaidAmount;
        private System.Windows.Forms.Label lblPayPlan;
        private System.Windows.Forms.Label lblGakuTotal;
        private System.Windows.Forms.Label lblTransferFeeGaku;
        private System.Windows.Forms.Label lblTransferGaku;
        private System.Windows.Forms.Label lblPayGaku;
        private System.Windows.Forms.Label lblPayConfirmGaku;
        private System.Windows.Forms.Label lblPayPlanGaku;
    }
}