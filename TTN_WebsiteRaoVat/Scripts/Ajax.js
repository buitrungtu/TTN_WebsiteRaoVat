$(document).ready(function () {
    $("#btnThich").click(function () {
        MaVP= $(this).data('id');
        SDT = $(this).data('sdt');
        if (SDT == "") {
            alert("Bạn phải đăng nhập để thực hiện chức năng này!");
        } else {
            ThichVatPham(MaVP, SDT); 
        }             
    })
    $(".DanhMuc").click(function () {
        maDM = $(this).data('id');
        HienVatPham(maDM);
    })
    $("#ThapToiCao").click(function () {
        maDM = $(this).data('madm');
        GiaThapToiCao(maDM);
    })
});  
function ThichVatPham(mavp, sdt) {
    var ThichVatPham = {
        MaVP: mavp,
        SDT: sdt
    };
    $.ajax({
        url: "/Product/ThichVatPham",
        data: JSON.stringify(ThichVatPham),
        type: "POST",
        contentType: "application/json;charset=utf-8",
        dataType: 'json',
        success: function (response) {
            if (response.status) {
                $(".Thich").toggleClass('DaThich');
            }
        },
    });
}
function HienVatPham(maDM) {
    $.ajax({
        type: "POST",
        url: "/Product/ShowVatPham",
        data: { MaDM: maDM },
        success: function (response) {
            $("#DanhSachVatPham").html(response);            
        }
    });
}
function GiaThapToiCao(maDM) {
    $.ajax({
        type: "POST",
        url: "/Product/SapXepTheoGiaTangDan",
        data: { MaDM: maDM },
        success: function (response) {
            $("#DanhSachVatPham").html(response);
        }
    });
}