using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TTN_WebsiteRaoVat.Common;
using TTN_WebsiteRaoVat.Models;

namespace TTN_WebsiteRaoVat.Controllers
{
    public class UserController : Controller
    {
        // GET: User
        TaiKhoanAccess tka = new TaiKhoanAccess();
        [HttpGet]
        public ActionResult DangNhap()
        {
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DangNhap(string SDT, string MatKhau)
        {
            if (tka.KiemTraDangNhap(SDT, MatKhau) == true && ModelState.IsValid)
            {
                TaiKhoan tk = tka.LayThongTinTaiKhoan(SDT);
                var userSesstion = new UserLogin();
                userSesstion.SDT = tk.SDT;
                Session.Add(CommonConstants.USER_SESSION, userSesstion);
                return Redirect("/Home");
            }
            else
            {
                ModelState.AddModelError("", "Ôi bạn ơi, Sai cái gì đấy rồi bạn ạ.");
            }
            return View("/DangNhap");
        }
        [HttpGet]
        public ActionResult DangKy()
        {
            return View();
        }
        [HttpPost]
        public ActionResult DangKy(string HoTen, string SDT, string Email, string MatKhau, string LoaiTK)
        {
            TaiKhoan tk = new TaiKhoan();
            tk.HoTen = HoTen;
            tk.SDT = SDT;
            tk.Email = Email;
            tk.MatKhau = MatKhau;
            tk.LoaiTaiKhoan = Int32.Parse(LoaiTK);

            if (tka.DangKyTaiKhoan(tk))
            {
                return Redirect("/DangNhap");
            }
            return View("/DangKy");
        }
        public ActionResult TrangCaNhan(string sdt)
        {
            TaiKhoan tk = tka.LayThongTinTaiKhoan(sdt);
            return View(tk);
        }
        public ActionResult ThayDoiThongTinCaNhan(string sdt)
        {
            TaiKhoan tk = tka.LayThongTinTaiKhoan(sdt);
            return View(tk);
        }
        public ActionResult DangXuat()
        {
            Session[CommonConstants.USER_SESSION] = null;
            return Redirect("/Home");
        }    
    }
}