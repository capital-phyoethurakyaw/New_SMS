﻿namespace TempoRegiZaikoKakunin
{
    partial class frmTempoRegiZaikoKakunin
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
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle37 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle38 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle42 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle39 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle40 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle41 = new System.Windows.Forms.DataGridViewCellStyle();
            this.ckmShop_Label1 = new CKM_Controls.CKMShop_Label();
            this.txtJanCD = new CKM_Controls.CKM_TextBox();
            this.btnInquery = new CKM_Controls.CKM_Button();
            this.ckmShop_Label5 = new CKM_Controls.CKMShop_Label();
            this.lblItemName = new CKM_Controls.CKMShop_Label();
            this.lblColorSize = new CKM_Controls.CKMShop_Label();
            this.chkColorSize = new CKM_Controls.CKMShop_CheckBox();
            this.dgvZaikokakunin = new CKM_Controls.CKMShop_GridView();
            this.lblZaiko = new CKM_Controls.CKMShop_Label();
            this.lblProduct = new CKM_Controls.CKMShop_Label();
            this.lblplandate = new CKM_Controls.CKMShop_Label();
            this.lblsou = new CKM_Controls.CKMShop_Label();
            this.lblallowsou = new CKM_Controls.CKMShop_Label();
            this.colWarehouse = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colProduct = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colDate = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colQuantity = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colNo = new System.Windows.Forms.DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)(this.dgvZaikokakunin)).BeginInit();
            this.SuspendLayout();
            // 
            // ckmShop_Label1
            // 
            this.ckmShop_Label1.AutoSize = true;
            this.ckmShop_Label1.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.ckmShop_Label1.BackColor = System.Drawing.Color.Transparent;
            this.ckmShop_Label1.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.ckmShop_Label1.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.ckmShop_Label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.ckmShop_Label1.Location = new System.Drawing.Point(33, 142);
            this.ckmShop_Label1.Name = "ckmShop_Label1";
            this.ckmShop_Label1.Size = new System.Drawing.Size(125, 35);
            this.ckmShop_Label1.TabIndex = 3;
            this.ckmShop_Label1.Text = "商　品";
            this.ckmShop_Label1.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.ckmShop_Label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // txtJanCD
            // 
            this.txtJanCD.AllowMinus = false;
            this.txtJanCD.Back_Color = CKM_Controls.CKM_TextBox.CKM_Color.Green;
            this.txtJanCD.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(226)))), ((int)(((byte)(239)))), ((int)(((byte)(218)))));
            this.txtJanCD.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.txtJanCD.ClientColor = System.Drawing.Color.FromArgb(((int)(((byte)(226)))), ((int)(((byte)(239)))), ((int)(((byte)(218)))));
            this.txtJanCD.Ctrl_Byte = CKM_Controls.CKM_TextBox.Bytes.半角;
            this.txtJanCD.Ctrl_Type = CKM_Controls.CKM_TextBox.Type.Normal;
            this.txtJanCD.DecimalPlace = 0;
            this.txtJanCD.Font = new System.Drawing.Font("MS Gothic", 26F);
            this.txtJanCD.IntegerPart = 0;
            this.txtJanCD.IsCorrectDate = true;
            this.txtJanCD.isEnterKeyDown = false;
            this.txtJanCD.isMaxLengthErr = false;
            this.txtJanCD.IsNumber = true;
            this.txtJanCD.IsShop = false;
            this.txtJanCD.Length = 13;
            this.txtJanCD.Location = new System.Drawing.Point(159, 139);
            this.txtJanCD.MaxLength = 13;
            this.txtJanCD.MoveNext = true;
            this.txtJanCD.Name = "txtJanCD";
            this.txtJanCD.Size = new System.Drawing.Size(260, 42);
            this.txtJanCD.TabIndex = 1;
            this.txtJanCD.TextSize = CKM_Controls.CKM_TextBox.FontSize.Medium;
            this.txtJanCD.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtJanCD_KeyDown);
            // 
            // btnInquery
            // 
            this.btnInquery.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(242)))), ((int)(((byte)(204)))));
            this.btnInquery.BackgroundColor = CKM_Controls.CKM_Button.CKM_Color.Yellow;
            this.btnInquery.Cursor = System.Windows.Forms.Cursors.Hand;
            this.btnInquery.DefaultBtnSize = true;
            this.btnInquery.FlatAppearance.BorderColor = System.Drawing.Color.Black;
            this.btnInquery.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnInquery.Font = new System.Drawing.Font("MS Gothic", 16F, System.Drawing.FontStyle.Bold);
            this.btnInquery.Font_Size = CKM_Controls.CKM_Button.CKM_FontSize.Medium;
            this.btnInquery.ForeColor = System.Drawing.Color.Black;
            this.btnInquery.Location = new System.Drawing.Point(1642, 139);
            this.btnInquery.Margin = new System.Windows.Forms.Padding(1);
            this.btnInquery.Name = "btnInquery";
            this.btnInquery.Size = new System.Drawing.Size(120, 35);
            this.btnInquery.TabIndex = 2;
            this.btnInquery.Text = "照会";
            this.btnInquery.UseVisualStyleBackColor = false;
            this.btnInquery.Click += new System.EventHandler(this.btnInquery_Click);
            // 
            // ckmShop_Label5
            // 
            this.ckmShop_Label5.AutoSize = true;
            this.ckmShop_Label5.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.ckmShop_Label5.BackColor = System.Drawing.Color.Transparent;
            this.ckmShop_Label5.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.ckmShop_Label5.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.ckmShop_Label5.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.ckmShop_Label5.Location = new System.Drawing.Point(155, 191);
            this.ckmShop_Label5.Name = "ckmShop_Label5";
            this.ckmShop_Label5.Size = new System.Drawing.Size(256, 35);
            this.ckmShop_Label5.TabIndex = 46;
            this.ckmShop_Label5.Text = "色サイズ違い ";
            this.ckmShop_Label5.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.ckmShop_Label5.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblItemName
            // 
            this.lblItemName.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblItemName.BackColor = System.Drawing.Color.Transparent;
            this.lblItemName.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblItemName.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblItemName.ForeColor = System.Drawing.Color.Black;
            this.lblItemName.Location = new System.Drawing.Point(499, 139);
            this.lblItemName.Name = "lblItemName";
            this.lblItemName.Size = new System.Drawing.Size(760, 50);
            this.lblItemName.TabIndex = 49;
            this.lblItemName.Text = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
            this.lblItemName.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblItemName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblItemName.Visible = false;
            // 
            // lblColorSize
            // 
            this.lblColorSize.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblColorSize.BackColor = System.Drawing.Color.Transparent;
            this.lblColorSize.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblColorSize.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblColorSize.ForeColor = System.Drawing.Color.Black;
            this.lblColorSize.Location = new System.Drawing.Point(510, 202);
            this.lblColorSize.Name = "lblColorSize";
            this.lblColorSize.Size = new System.Drawing.Size(550, 30);
            this.lblColorSize.TabIndex = 50;
            this.lblColorSize.Text = "XXXXXXXXXXX";
            this.lblColorSize.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblColorSize.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.lblColorSize.Visible = false;
            // 
            // chkColorSize
            // 
            this.chkColorSize.Location = new System.Drawing.Point(396, 193);
            this.chkColorSize.Name = "chkColorSize";
            this.chkColorSize.Size = new System.Drawing.Size(30, 30);
            this.chkColorSize.TabIndex = 51;
            this.chkColorSize.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.chkColorSize.UseVisualStyleBackColor = true;
            // 
            // dgvZaikokakunin
            // 
            this.dgvZaikokakunin.AllowUserToAddRows = false;
            this.dgvZaikokakunin.AllowUserToDeleteRows = false;
            this.dgvZaikokakunin.AllowUserToResizeRows = false;
            this.dgvZaikokakunin.AlterBackColor = CKM_Controls.CKMShop_GridView.AltBackcolor.Control;
            dataGridViewCellStyle37.BackColor = System.Drawing.SystemColors.Control;
            this.dgvZaikokakunin.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle37;
            this.dgvZaikokakunin.BackgroundColor = System.Drawing.Color.White;
            this.dgvZaikokakunin.BackgroungColor = CKM_Controls.CKMShop_GridView.DBackcolor.White;
            this.dgvZaikokakunin.BorderStyle = System.Windows.Forms.BorderStyle.None;
            dataGridViewCellStyle38.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle38.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(191)))), ((int)(((byte)(191)))), ((int)(((byte)(191)))));
            dataGridViewCellStyle38.Font = new System.Drawing.Font("MS Gothic", 18F);
            dataGridViewCellStyle38.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle38.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle38.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle38.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dgvZaikokakunin.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle38;
            this.dgvZaikokakunin.ColumnHeadersHeight = 22;
            this.dgvZaikokakunin.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            this.dgvZaikokakunin.ColumnHeadersVisible = false;
            this.dgvZaikokakunin.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.colWarehouse,
            this.colProduct,
            this.colDate,
            this.colQuantity,
            this.colNo});
            dataGridViewCellStyle42.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle42.BackColor = System.Drawing.Color.White;
            dataGridViewCellStyle42.Font = new System.Drawing.Font("MS Gothic", 18F);
            dataGridViewCellStyle42.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle42.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle42.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle42.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.dgvZaikokakunin.DefaultCellStyle = dataGridViewCellStyle42;
            this.dgvZaikokakunin.DGVback = CKM_Controls.CKMShop_GridView.DGVBackcolor.White;
            this.dgvZaikokakunin.EnableHeadersVisualStyles = false;
            this.dgvZaikokakunin.Font = new System.Drawing.Font("MS Gothic", 18F);
            this.dgvZaikokakunin.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(198)))), ((int)(((byte)(224)))), ((int)(((byte)(180)))));
            this.dgvZaikokakunin.GVFontstyle = CKM_Controls.CKMShop_GridView.FontStyle_.Regular;
            this.dgvZaikokakunin.HeaderHeight_ = 22;
            this.dgvZaikokakunin.HeaderVisible = false;
            this.dgvZaikokakunin.Height_ = 200;
            this.dgvZaikokakunin.Location = new System.Drawing.Point(73, 307);
            this.dgvZaikokakunin.Name = "dgvZaikokakunin";
            this.dgvZaikokakunin.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dgvZaikokakunin.RowHeight_ = 42;
            this.dgvZaikokakunin.RowTemplate.Height = 42;
            this.dgvZaikokakunin.ShopFontSize = CKM_Controls.CKMShop_GridView.Font_.Medium;
            this.dgvZaikokakunin.Size = new System.Drawing.Size(1700, 400);
            this.dgvZaikokakunin.TabIndex = 48;
            this.dgvZaikokakunin.UseRowNo = true;
            this.dgvZaikokakunin.UseSetting = true;
            this.dgvZaikokakunin.Width_ = 1700;
            this.dgvZaikokakunin.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvZaikokakunin_CellDoubleClick);
            // 
            // lblZaiko
            // 
            this.lblZaiko.AutoSize = true;
            this.lblZaiko.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblZaiko.BackColor = System.Drawing.Color.Transparent;
            this.lblZaiko.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblZaiko.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblZaiko.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.lblZaiko.Location = new System.Drawing.Point(125, 264);
            this.lblZaiko.Name = "lblZaiko";
            this.lblZaiko.Size = new System.Drawing.Size(163, 35);
            this.lblZaiko.TabIndex = 52;
            this.lblZaiko.Text = "在庫倉庫";
            this.lblZaiko.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.lblZaiko.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblProduct
            // 
            this.lblProduct.AutoSize = true;
            this.lblProduct.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblProduct.BackColor = System.Drawing.Color.Transparent;
            this.lblProduct.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblProduct.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblProduct.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.lblProduct.Location = new System.Drawing.Point(420, 264);
            this.lblProduct.Name = "lblProduct";
            this.lblProduct.Size = new System.Drawing.Size(125, 35);
            this.lblProduct.TabIndex = 53;
            this.lblProduct.Text = "商　品";
            this.lblProduct.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.lblProduct.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblplandate
            // 
            this.lblplandate.AutoSize = true;
            this.lblplandate.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblplandate.BackColor = System.Drawing.Color.Transparent;
            this.lblplandate.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblplandate.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblplandate.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.lblplandate.Location = new System.Drawing.Point(1232, 263);
            this.lblplandate.Name = "lblplandate";
            this.lblplandate.Size = new System.Drawing.Size(200, 35);
            this.lblplandate.TabIndex = 54;
            this.lblplandate.Text = "入荷予定日";
            this.lblplandate.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.lblplandate.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblsou
            // 
            this.lblsou.AutoSize = true;
            this.lblsou.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblsou.BackColor = System.Drawing.Color.Transparent;
            this.lblsou.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblsou.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblsou.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.lblsou.Location = new System.Drawing.Point(1471, 264);
            this.lblsou.Name = "lblsou";
            this.lblsou.Size = new System.Drawing.Size(126, 35);
            this.lblsou.TabIndex = 55;
            this.lblsou.Text = "在庫数";
            this.lblsou.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.lblsou.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblallowsou
            // 
            this.lblallowsou.AutoSize = true;
            this.lblallowsou.Back_Color = CKM_Controls.CKMShop_Label.CKM_Color.Default;
            this.lblallowsou.BackColor = System.Drawing.Color.Transparent;
            this.lblallowsou.Font = new System.Drawing.Font("MS Gothic", 26F, System.Drawing.FontStyle.Bold);
            this.lblallowsou.Font_Size = CKM_Controls.CKMShop_Label.CKM_FontSize.Normal;
            this.lblallowsou.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(84)))), ((int)(((byte)(130)))), ((int)(((byte)(53)))));
            this.lblallowsou.Location = new System.Drawing.Point(1603, 264);
            this.lblallowsou.Name = "lblallowsou";
            this.lblallowsou.Size = new System.Drawing.Size(145, 35);
            this.lblallowsou.TabIndex = 56;
            this.lblallowsou.Text = " 可能数";
            this.lblallowsou.Text_Color = CKM_Controls.CKMShop_Label.CKM_Color.Green;
            this.lblallowsou.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // colWarehouse
            // 
            this.colWarehouse.DataPropertyName = "SoukoName";
            this.colWarehouse.HeaderText = "在庫倉庫";
            this.colWarehouse.Name = "colWarehouse";
            this.colWarehouse.ReadOnly = true;
            this.colWarehouse.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.colWarehouse.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.colWarehouse.Width = 300;
            // 
            // colProduct
            // 
            this.colProduct.DataPropertyName = "JanCD";
            this.colProduct.HeaderText = "商　品";
            this.colProduct.Name = "colProduct";
            this.colProduct.ReadOnly = true;
            this.colProduct.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.colProduct.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.colProduct.Width = 800;
            // 
            // colDate
            // 
            this.colDate.DataPropertyName = "ArrivalPlanDate";
            dataGridViewCellStyle39.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            this.colDate.DefaultCellStyle = dataGridViewCellStyle39;
            this.colDate.HeaderText = "入荷予定日";
            this.colDate.MaxInputLength = 8;
            this.colDate.Name = "colDate";
            this.colDate.ReadOnly = true;
            this.colDate.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.colDate.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.colDate.Width = 230;
            // 
            // colQuantity
            // 
            this.colQuantity.DataPropertyName = "ZaikouSu";
            dataGridViewCellStyle40.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            this.colQuantity.DefaultCellStyle = dataGridViewCellStyle40;
            this.colQuantity.HeaderText = "在庫数";
            this.colQuantity.Name = "colQuantity";
            this.colQuantity.ReadOnly = true;
            this.colQuantity.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.colQuantity.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.colQuantity.Width = 150;
            // 
            // colNo
            // 
            this.colNo.DataPropertyName = "KanoSu";
            dataGridViewCellStyle41.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleRight;
            this.colNo.DefaultCellStyle = dataGridViewCellStyle41;
            this.colNo.HeaderText = "可能数";
            this.colNo.Name = "colNo";
            this.colNo.ReadOnly = true;
            this.colNo.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.colNo.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.colNo.Width = 150;
            // 
            // frmTempoRegiZaikoKakunin
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1840, 961);
            this.Controls.Add(this.lblallowsou);
            this.Controls.Add(this.lblsou);
            this.Controls.Add(this.lblplandate);
            this.Controls.Add(this.lblProduct);
            this.Controls.Add(this.lblZaiko);
            this.Controls.Add(this.chkColorSize);
            this.Controls.Add(this.lblColorSize);
            this.Controls.Add(this.lblItemName);
            this.Controls.Add(this.dgvZaikokakunin);
            this.Controls.Add(this.ckmShop_Label5);
            this.Controls.Add(this.btnInquery);
            this.Controls.Add(this.txtJanCD);
            this.Controls.Add(this.ckmShop_Label1);
            this.Name = "frmTempoRegiZaikoKakunin";
            this.Text = "店舗レジ 在庫確認";
            this.Load += new System.EventHandler(this.frmTempoRegiZaikoKakunin_Load);
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.frmTempoRegiZaikoKakunin_KeyUp);
            this.Controls.SetChildIndex(this.ckmShop_Label1, 0);
            this.Controls.SetChildIndex(this.txtJanCD, 0);
            this.Controls.SetChildIndex(this.btnInquery, 0);
            this.Controls.SetChildIndex(this.ckmShop_Label5, 0);
            this.Controls.SetChildIndex(this.dgvZaikokakunin, 0);
            this.Controls.SetChildIndex(this.lblItemName, 0);
            this.Controls.SetChildIndex(this.lblColorSize, 0);
            this.Controls.SetChildIndex(this.chkColorSize, 0);
            this.Controls.SetChildIndex(this.lblZaiko, 0);
            this.Controls.SetChildIndex(this.lblProduct, 0);
            this.Controls.SetChildIndex(this.lblplandate, 0);
            this.Controls.SetChildIndex(this.lblsou, 0);
            this.Controls.SetChildIndex(this.lblallowsou, 0);
            ((System.ComponentModel.ISupportInitialize)(this.dgvZaikokakunin)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private CKM_Controls.CKMShop_Label ckmShop_Label1;
        private CKM_Controls.CKM_TextBox txtJanCD;
        private CKM_Controls.CKM_Button btnInquery;
        private CKM_Controls.CKMShop_Label ckmShop_Label5;
        private CKM_Controls.CKMShop_Label lblItemName;
        private CKM_Controls.CKMShop_Label lblColorSize;
        private CKM_Controls.CKMShop_CheckBox chkColorSize;
        private CKM_Controls.CKMShop_GridView dgvZaikokakunin;
        private CKM_Controls.CKMShop_Label lblZaiko;
        private CKM_Controls.CKMShop_Label lblProduct;
        private CKM_Controls.CKMShop_Label lblplandate;
        private CKM_Controls.CKMShop_Label lblsou;
        private CKM_Controls.CKMShop_Label lblallowsou;
        private System.Windows.Forms.DataGridViewTextBoxColumn colWarehouse;
        private System.Windows.Forms.DataGridViewTextBoxColumn colProduct;
        private System.Windows.Forms.DataGridViewTextBoxColumn colDate;
        private System.Windows.Forms.DataGridViewTextBoxColumn colQuantity;
        private System.Windows.Forms.DataGridViewTextBoxColumn colNo;
    }
}