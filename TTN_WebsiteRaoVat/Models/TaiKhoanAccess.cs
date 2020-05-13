using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace TTN_WebsiteRaoVat.Models
{
    public class TaiKhoanAccess : DatabaseAccess
    {
        public bool KiemTraDangNhap(string sdt, string matkhau)
        {
            OpenConnection();
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = "select * from TaiKhoan where SDT = @sdt and MatKhau = @matkhau";
            command.Connection = conn;
            command.Parameters.Add("@sdt", SqlDbType.NChar).Value = sdt;
            command.Parameters.Add("@matkhau", SqlDbType.NChar).Value = matkhau;
            SqlDataReader reader = command.ExecuteReader();
            if (reader.Read())
            {
                reader.Close();
                return true;
            }
            return false;
        }
        public TaiKhoan LayThongTinTaiKhoan(string sdt)
        {
            TaiKhoan tk = new TaiKhoan();
            OpenConnection();
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = "select * from dbo.LayThongTinTaiKhoan(@sdt)";
            command.Connection = conn;
            command.Parameters.Add("@sdt", SqlDbType.NChar).Value = sdt;
            SqlDataReader reader = command.ExecuteReader();
            if (reader.Read())
            {
                tk.SDT = reader.GetString(0);
                tk.MatKhau = reader.GetString(1);
                tk.LoaiTaiKhoan = reader.GetInt32(2);
                if (!reader.IsDBNull(9))
                {
                    tk.NgayTao = reader.GetDateTime(3).ToString("dd/MM/yyyy");
                }
                else
                {
                    tk.NgayTao = "Chưa có";
                }
                tk.HoTen = reader.GetString(4);
                tk.Email = reader.GetString(5);
                tk.QueQuan = reader.GetString(6);
                tk.GioiTinh = reader.GetString(7);
                tk.AnhDaiDien = reader.GetString(8);
                if (!reader.IsDBNull(9))
                {
                    tk.NgaySinh = reader.GetDateTime(8).ToString("dd/MM/yyyy");
                }
                else
                {
                    tk.NgaySinh = "Chưa có";
                }
            }
            return tk;
        }
        public bool DangKyTaiKhoan(TaiKhoan tk)
        {
            OpenConnection();
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "DangKy";
            command.Connection = conn;
            command.Parameters.Add("@HoTen", SqlDbType.NVarChar).Value = tk.HoTen;
            command.Parameters.Add("@SDT", SqlDbType.NChar).Value = tk.SDT;
            command.Parameters.Add("@LoaiTK", SqlDbType.Int).Value = tk.LoaiTaiKhoan;
            command.Parameters.Add("@email", SqlDbType.NChar).Value = tk.Email;
            command.Parameters.Add("@matkhau", SqlDbType.NChar).Value = tk.MatKhau;
            int ret = command.ExecuteNonQuery();
            if (ret > 0)
            {
                return true;
            }
            return false;
        }
    }
}