document.addEventListener("DOMContentLoaded",function() {


	$('.MuiTenXuong').click(function(event) {
		$('.MuiTen').toggleClass('HienLen');
		$('.ThongBao').removeClass('HienLen');
	});

	$('.BaoXau').click(function(event) {

		$('.DS-BaoXau').toggleClass('HienLen');
	});

	$('.Chuong').click(function(event) {
		$('.ThongBao').toggleClass('HienLen');
		$('.SLTB').addClass('BienMat');
		$('.MuiTen').removeClass('HienLen');
	});

	$('.container').click(function(event) {
		
		$('.MuiTen').removeClass('HienLen');
		$('.ThongBao').removeClass('HienLen');
	});

	$('.DatMua').click(function(event) {
		$('.ThongTinMuaHang').addClass('HienLen');
		$('.LamMo').addClass('HienLen');
	});

	$('.LamMo,.submit').click(function(event) {
		$('.ThongTinMuaHang').removeClass('HienLen');
		$('.LamMo').removeClass('HienLen');
	});
	

},false)
