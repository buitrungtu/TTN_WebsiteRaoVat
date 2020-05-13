using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TTN_WebsiteRaoVat.Controllers
{
    public class ProductController : Controller
    {
        VatPhamAccess vpa = new VatPhamAccess();

        public ActionResult Index()
        {
            return View();
        }
        [ChildActionOnly]
        public ActionResult DanhSachVatPham()
        {
            List<VatPham> dsvp = vpa.LayToanBoVatPham();
            return PartialView(dsvp);
        }
        public ActionResult ChiTietVatPham(int MaVP)
        {
            VatPham vp = vpa.ThongTinChiTietVatPham(MaVP);
            return View(vp);
        }
        public ActionResult DangTinBan(string SDT)
        {
            return View();
        }
        [HttpPost]
        public ActionResult DangTinBan
            (string SDT, string TheLoai, string TieuDe, string MoTa, string TinhTrang, string GiaTien,
                string HoTen, string ThanhPho, string QuanHuyen, string Email, ImageFile objImage)
        {

            return View();
        }
        public class ImageFile
        {
            public List<HttpPostedFileBase> files { get; set; }
        }
    }
}