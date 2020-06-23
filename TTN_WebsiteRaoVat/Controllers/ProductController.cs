using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;
using TTN_WebsiteRaoVat.Models;

namespace TTN_WebsiteRaoVat.Controllers
{
    public class ProductController : Controller
    {
        VatPhamAccess vpa = new VatPhamAccess();

        public ActionResult Index(int MaDM)
        {
            List<VatPham> dsvp = vpa.LayVatPham(MaDM);
            // mặc định là mới nhất lên đầu
            dsvp = dsvp.OrderBy(x => x.NgayDang).ToList();
            ViewBag.MaDM = MaDM; 
            return View(dsvp);
        }
        public ActionResult TimKiem(string strTimKiem, string TheLoai)
        {
            List<VatPham> dsvp = vpa.TimKiemVP(strTimKiem, Int32.Parse(TheLoai));
            dsvp = dsvp.OrderBy(x => x.NgayDang).ToList();
            return View(dsvp);
        }
        public ActionResult ShowVatPham(int MaDM, int tieuchi)
        {
            List<VatPham> dsvp = vpa.LayVatPham(MaDM);
            ViewBag.MaDM = MaDM;
            ViewBag.TieuChi = tieuchi;
            if (tieuchi == 0)
            {                               
                dsvp = dsvp.OrderBy(x => x.NgayDang).ToList();                
            }
            else if(tieuchi == 1)
            {               
                dsvp = dsvp.OrderBy(x => x.GiaTien).ToList();                               
            }
            else
            {               
                dsvp = dsvp.OrderBy(x => x.GiaTien).ToList();
                dsvp.Reverse();               
            }
            return PartialView(dsvp);
        }
        
        public ActionResult LocTheoGia(int MaDM,long min,long max,int tieuchi)
        {
            List<VatPham> dsvp = vpa.LayVatPham(MaDM);
            ViewBag.MaDM = MaDM;
            ViewBag.TieuChi = tieuchi;
            ViewBag.min = min;
            ViewBag.max = max;
            min = min * 1000000;
            if (max < 1500)
            {                
                max = max * 1000000;
                dsvp = dsvp.Where(x => x.GiaTien > min && x.GiaTien < max).ToList();
            }
            else
            {
                dsvp = dsvp.Where(x => x.GiaTien > min).ToList();
            }
            if (tieuchi == 0)
            {
                dsvp = dsvp.OrderBy(x => x.NgayDang).ToList();
            }
            else if (tieuchi == 1)
            {
                dsvp = dsvp.OrderBy(x => x.GiaTien).ToList();
            }
            else
            {
                dsvp = dsvp.OrderBy(x => x.GiaTien).ToList();
                dsvp.Reverse();
            }
            return PartialView(dsvp);
        }
        public ActionResult ChiTietVatPham(int MaVP)
        {

            VatPham vp = vpa.ThongTinChiTietVatPham(MaVP);
            return View(vp);
        }
        public ActionResult BaoXau(string SDT,int MaVP,string LyDo,string GhiChu)
        {
            if (vpa.BaoXauVatPham(SDT, MaVP, LyDo, GhiChu))
            {
                return RedirectToAction("ChiTietVatPham", "Product", new { MaVP = MaVP });
            }
            return RedirectToAction("ChiTietVatPham", "Product", new { MaVP = MaVP });
        }
        public ActionResult DatMua(string SDT, int MaVP, string TenNM,string Email,string DiaChi ,string GhiChu)
        {
            if (vpa.DatMuaSanPham(SDT, MaVP, TenNM,Email,DiaChi, GhiChu))
            {
                return RedirectToAction("ChiTietVatPham", "Product", new { MaVP = MaVP });
            }
            return RedirectToAction("ChiTietVatPham", "Product", new { MaVP = MaVP });
        }
        public JsonResult ThichVatPham(ThichVatPham temp)
        {
            if (vpa.DaThich(temp.SDT, Int32.Parse(temp.MaVP)) == false && vpa.ThichVatPham(temp) == true)
            {
                return Json(new
                {
                    status = true
                });
            }
            else if (vpa.BoThich(temp))
            {
                return Json(new
                {
                    status = true
                });
            }
            else
            {
                return Json(new
                {
                    status = false
                });
            }
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
            string strLink = "";
            VatPhamAccess vpa = new VatPhamAccess();
            foreach (var file in objImage.files)
            {
                if (file != null && file.ContentLength > 0)
                {
                    string fileName = Path.Combine(Server.MapPath("/Content/uploads"), Guid.NewGuid() + Path.GetExtension(file.FileName));
                    strLink += fileName + ',';
                    file.SaveAs(fileName);
                }
            }
            string[] temp = strLink.Split(',');
            int MaTinhThanh = Int32.Parse(ThanhPho);
            long giaTien = long.Parse(GiaTien);
            int theloai = Int32.Parse(TheLoai);
            if (vpa.ThemVatPham(SDT, HoTen, MaTinhThanh, QuanHuyen, TieuDe, MoTa, TinhTrang, giaTien, theloai, temp[0], strLink))
            {
                return RedirectToAction("Index", "Product", new {MaDM = theloai});
            }
            return View("DangTinBan");
        }    
    }
    public class ImageFile
    {
        public List<HttpPostedFileBase> files { get; set; }
    }
}