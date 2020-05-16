using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;


namespace TTN_WebsiteRaoVat.Models
{
    public class VatPhamAccess : DatabaseAccess
    {
        public List<TinhThanh> LayTinhThanh()
        {
            List<TinhThanh> kq = new List<TinhThanh>();
            OpenConnection();
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = "select * from Tinh_Thanh";
            command.Connection = conn;
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                TinhThanh temp = new TinhThanh();
                temp.MaTinhThanh = reader.GetInt32(0);
                temp.TenTinhThanh = reader.GetString(1);
                kq.Add(temp);
            }
            reader.Close();
            return kq;
        }
        public List<DanhMuc> LayDanhMuc()
        {
            List<DanhMuc> kq = new List<DanhMuc>();
            OpenConnection();
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = "select * from TheLoai";
            command.Connection = conn;
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                DanhMuc temp = new DanhMuc();
                temp.MaDanhMuc = reader.GetInt32(0);
                temp.TenDanhMuc = reader.GetString(1);
                kq.Add(temp);
            }
            reader.Close();
            return kq;
        }
        public List<VatPham> LayToanBoVatPham()
        {
            List<VatPham> dsvp = new List<VatPham>();
            OpenConnection();
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = "select * from dbo.ThongTinVatPham(0)";
            command.Connection = conn;
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                VatPham vp = new VatPham();
                vp.MaVP = reader.GetInt32(0);
                vp.TenVP = reader.GetString(1);
                vp.TenNguoiBan = reader.GetString(2);
                vp.SDT = reader.GetString(3);
                vp.ThanhPho = reader.GetString(4);
                vp.MoTa = reader.GetString(5);
                vp.TinhTrang = reader.GetString(6);
                vp.GiaTien = reader.GetInt64(7);
                vp.TheLoai = reader.GetString(8);
                int temp = reader.GetInt32(9);
                vp.NgayDang = ChuyenThoiGian(temp);
                vp.LinkHinhAnh = new List<string>();
                vp.LinkHinhAnh.Add(reader.GetString(10));
                vp.ChatLuong = reader.GetInt32(11);
                vp.DiaDiem = reader.GetString(12);
                dsvp.Add(vp);
            }
            reader.Close();
            return dsvp;
        }
        public VatPham ThongTinChiTietVatPham(int MaVP)
        {
            VatPham vp = new VatPham();
            try
            {
                OpenConnection();
                SqlCommand command = new SqlCommand();
                command.CommandType = CommandType.Text;
                command.CommandText = "select * from dbo.ThongTinVatPham(@MaVP)";
                command.Connection = conn;
                command.Parameters.Add("@MaVP", SqlDbType.Int).Value = MaVP;
                SqlDataReader reader = command.ExecuteReader();
                if (reader.Read())
                {
                    vp.MaVP = reader.GetInt32(0);
                    vp.TenVP = reader.GetString(1);
                    vp.TenNguoiBan = reader.GetString(2);
                    vp.SDT = reader.GetString(3);
                    vp.ThanhPho = reader.GetString(4);
                    vp.MoTa = reader.GetString(5);
                    vp.TinhTrang = reader.GetString(6);
                    vp.GiaTien = reader.GetInt64(7);
                    vp.TheLoai = reader.GetString(8);
                    int temp = reader.GetInt32(9);
                    vp.NgayDang = ChuyenThoiGian(temp);
                    vp.ChatLuong = reader.GetInt32(11);
                    vp.DiaDiem = reader.GetString(12);
                    reader.Close();
                    vp.LinkHinhAnh = LayHinhAnh(vp.MaVP);
                }
            }
            catch
            {

            }
            return vp;
        }
        List<string> LayHinhAnh(int MaVP)
        {
            List<string> linkAnh = new List<string>();
            OpenConnection();
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = "select * from dbo.LayHinhAnh(@MaVP)";
            command.Connection = conn;
            command.Parameters.Add("@MaVP", SqlDbType.Int).Value = MaVP;
            SqlDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                string link = reader.GetString(0);
                linkAnh.Add(link);
            }
            reader.Close();
            return linkAnh;
        }
        public bool ThemVatPham(
            string SDT, string HoTen, int MaTinhThanh, string DiaChi, string TenVP, string MoTa,
            string TinhTrang, long GiaTien, int MaTL, string LinkHinhAnh, string strLink
            )
        {
            OpenConnection();
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "ThemVatPham";
            command.Connection = conn;

            command.Parameters.Add("@SDT", SqlDbType.NChar).Value = SDT;
            command.Parameters.Add("@HoTen", SqlDbType.NVarChar).Value = HoTen;
            command.Parameters.Add("@MaTinhThanh", SqlDbType.Int).Value = MaTinhThanh;
            command.Parameters.Add("@DiaChi", SqlDbType.NVarChar).Value = DiaChi;

            command.Parameters.Add("@TenVP", SqlDbType.NVarChar).Value = TenVP;
            command.Parameters.Add("@MoTa", SqlDbType.NVarChar).Value = MoTa;
            command.Parameters.Add("@TinhTrang", SqlDbType.NVarChar).Value = TinhTrang;
            command.Parameters.Add("@GiaTien", SqlDbType.BigInt).Value = GiaTien;
            command.Parameters.Add("@MaTL", SqlDbType.Int).Value = MaTL;
            command.Parameters.Add("@LinkHinhAnh", SqlDbType.NVarChar).Value = LinkHinhAnh;

            command.Parameters.Add("@strLink", SqlDbType.NVarChar).Value = strLink;

            int ret = command.ExecuteNonQuery();

            if (ret > 0)
            {
                return true;
            }
            return false;
        }
        
        public int ThichVatPham(ThichVatPham temp)
        {
            OpenConnection();
            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.StoredProcedure;
            command.CommandText = "ThichSanPham";
            command.Connection = conn;

            command.Parameters.Add("@sdt", SqlDbType.NChar).Value = temp.SDT;
            command.Parameters.Add("@mavp", SqlDbType.Int).Value = Int32.Parse(temp.MaVP);

            int ret = command.ExecuteNonQuery();

            return ret;
           
        }
        string ChuyenThoiGian(int gio)
        {
            if (gio < 24)
            {
                return gio.ToString() + " giờ trước";
            }
            else if (gio >= 24 && gio < 168)
            {
                return (gio / 24).ToString() + " ngày trước";
            }
            else if (gio >= 168 && gio < 672)
            {
                return (gio / 168).ToString() + " tuần trước";
            }
            else if (gio >= 672 && gio < 8064)
            {
                return (gio / 672).ToString() + " tháng trước";
            }
            else
            {
                return (gio / 8064).ToString() + " năm trước";
            }
        }
    }
}