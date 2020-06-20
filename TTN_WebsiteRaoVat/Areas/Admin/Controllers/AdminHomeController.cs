using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TTN_WebsiteRaoVat.Models;
namespace TTN_WebsiteRaoVat.Areas.Admin.Controllers
{
    public class AdminHomeController : Controller
    {
        NhanVienAccess nvac = new NhanVienAccess();

        // GET: Admin/Home
        public ActionResult Index()
        {

            return View();
        }
        public ActionResult DuyetVatPham()
        {

            return View();
        }
        public ActionResult VatPhamBiKhoa()
        {

            return View();
        }
        public ActionResult TaiKhoanBiKhoa()
        {

            return View();
        }

        public ActionResult LoginAdmin()
        {

            return View();
        }
        [HttpPost]
        public ActionResult LoginAdmin(string username, string pass)
        {
            if (nvac.KiemTraDangNhap(username, pass) == true && ModelState.IsValid)
            {

                return Redirect("AdminHome");
            }
            else
            {
                return View("LoginAdmin");
            }


        }
        public ActionResult XemTruoc()
        {
            return View();
        }
        public ActionResult Xoa(int id)
        {

            return RedirectToAction("Index");
        }

    }
}