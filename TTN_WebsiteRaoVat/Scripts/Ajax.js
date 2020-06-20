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
        HienVatPham(maDM,0);
    })

    $("#SapXep").click(function () {
        tieuchi = $('#TieuChi').val();
        MaDM = $(this).data('madm');
        HienVatPham(MaDM, tieuchi);     
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
function HienVatPham(maDM, tc) {
    $.ajax({
        async: true,
        type: "POST",
        url: "/Product/ShowVatPham",
        data: { MaDM: maDM, tieuchi: tc},
        success: function (response) {        
            $("#DanhSachVatPham").html(response);            
        }
    });
}
