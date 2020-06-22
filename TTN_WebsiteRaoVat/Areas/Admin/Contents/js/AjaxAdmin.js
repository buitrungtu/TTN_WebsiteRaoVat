$(document).ready(function () {
    $(".Khoa").click(function () {
        MaVP = $(this).data('id');
        KhoaVatPham(MaVP);
    })
    $(".MoKhoa").click(function () {
        MaVP = $(this).data('id');
        MoKhoaVatPham(MaVP);
    })
    $(".Duyet").click(function () {
        MaVP = $(this).data('id');
        DuyetVatPham(MaVP);
    })
    $(".Xoa").click(function () {
        var r = confirm("Bấm OK để xóa");
        if (r == true) {
            MaVP = $(this).data('id');
            XoaVatPham(MaVP);
<<<<<<< HEAD
        }       
=======
        }
>>>>>>> aca3bbe99b2ac1aec9c4c83b841df9954b9204ce
    })
});
function KhoaVatPham(MaVP) {
    $.ajax({
        async: true,
        type: "POST",
        url: "/XuLyAdmin/KhoaVatPham",
<<<<<<< HEAD
        data: { MaVP: MaVP},
=======
        data: { MaVP: MaVP },
>>>>>>> aca3bbe99b2ac1aec9c4c83b841df9954b9204ce
        success: function (response) {
            if (response.status) {
                alert("Khóa thành công!")
            } else {
                alert("Vật phẩm này hiện đang bị khóa!");
            }
        }
    });
}
function MoKhoaVatPham(MaVP) {
    $.ajax({
        async: true,
        type: "POST",
        url: "/XuLyAdmin/MoKhoaVatPham",
        data: { MaVP: MaVP },
        success: function (response) {
            if (response.status) {
                alert("Mở khóa thành công!");
                location.reload();
            } else {
                alert("Mở khóa thất bại!");
            }
        }
    });
}
function DuyetVatPham(MaVP) {
    $.ajax({
        async: true,
        type: "POST",
        url: "/XuLyAdmin/DuyetVatPham",
        data: { MaVP: MaVP },
        success: function (response) {
            if (response.status) {
                alert("Đã duyệt");
                location.reload();
            } else {
                alert("Duyệt vật phẩm thất bại");
            }
        }
    });
}
function XoaVatPham(MaVP) {
    $.ajax({
        async: true,
        type: "POST",
        url: "/XuLyAdmin/XoaVatPham",
        data: { MaVP: MaVP },
        success: function (response) {
            if (response.status) {
                alert("Xóa thành công!");
                location.reload();
            } else {
                alert("Xóa thất bại");
            }
        }
    });
}