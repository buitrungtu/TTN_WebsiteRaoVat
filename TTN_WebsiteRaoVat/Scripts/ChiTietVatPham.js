var ChiTietVatPham = {
    init: function () {
        ChiTietVatPham.HanhDong();

    }, HanhDong: function () {
        $('.btn-Thich').click(function () {                                  
            if (SDT == '') {
                alert = ('Dang nhap da ban eii');
            } else {
                alert = ('Da luu duoc chua')
                var thich = {
                    MaVP: $(this).data('id'),
                    SDT: $(this).data('sdt')
                }
                $.ajax({
                    url: '/Product/ThichVatPham',
                    data: JSON.stringify(thich),
                    type: 'POST',
                    contentType: "application/json;charset=utf-8",
                    dataType: 'json',
                    success: function (response) {
                        if (response.status) {
                            alert('Like thanh cong');
                        } else {
                            alert('Update failed');
                        }
                    }
                })
            }                
        })
    },
    
}
ChiTietVatPham.init();