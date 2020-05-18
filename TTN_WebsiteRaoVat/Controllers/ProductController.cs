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
       
        public JsonResult ThichVatPham(ThichVatPham temp)
        {
            if (vpa.DaThich(temp.SDT,Int32.Parse(temp.MaVP)) == false  && vpa.ThichVatPham(temp)==true)
            {
                return Json(new
                {
                    status = true
                });
            }
            else if(vpa.BoThich(temp))
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
                return View("Index");
            }
            return View("DangTinBan");
        }    
    }
    public class ImageFile
    {
        public List<HttpPostedFileBase> files { get; set; }
    }
}