$(document).ready(function () {
    $(".btn-Thich").click(function () {
        MaVP= $(this).data('id');
        SDT = $(this).data('sdt');
        if (SDT == null) {
            alert('Bạn chưa đăng nhập');
        } else {
            ThichVatPham(MaVP, SDT); 
        }             
    })
    $(".DanhMuc").click(function () {
        maDM = $(this).data('id');
        HienVatPham(maDM);
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