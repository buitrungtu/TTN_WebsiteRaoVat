$(document).ready(function () {
    $(".btn-Thich").click(function () {
        MaVP= $(this).data('id');
        SDT = $(this).data('sdt');       
        ThichVatPham(MaVP, SDT);
        
    })
});  
function ThichVatPham(mavp,sdt) {
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