create database  [Website_RaoVat]
go
USE [Website_RaoVat]
GO
/****** Object:  UserDefinedFunction [dbo].[DanhSachVatPham]    Script Date: 6/19/2020 10:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[DanhSachVatPham](@MaDM int)
returns @BangChiTiet table(
	MaVP int,TenVP nvarchar(500),HoTen nvarchar(500),SDT varchar(50), TenTinhThanh nvarchar(500),
	MoTa nvarchar(max), TinhTrang nvarchar(500),GiaTien bigint,
	TenTL nvarchar(500),NgayDang int,LinkHinhAnh varchar(Max),ChatLuong int,
	DiaChi nvarchar(500)
)as begin
	if(@MaDM = 0)
	begin
		insert into @BangChiTiet
			select MaVP,TenVP,HoTen,SDT,TenTinhThanh,MoTa,TinhTrang,GiaTien,TenTL,
			DATEDIFF(HOUR,NgayDang,GETDATE()),LinkHinhAnh,ChatLuong,NguoiBan.DiaChi
			from VatPham,NguoiBan,Tinh_Thanh,TheLoai
			where VatPham.MaNB = NguoiBan.MaNB
				and NguoiBan.MaTinhThanh = Tinh_Thanh.MaTinhThanh
				and VatPham.MaTL = TheLoai.MaTL
	end
	else
	begin
		insert into @BangChiTiet
			select MaVP,TenVP,HoTen,SDT,TenTinhThanh,MoTa,TinhTrang,GiaTien,TenTL,
			DATEDIFF(HOUR,NgayDang,GETDATE()),LinkHinhAnh,ChatLuong,NguoiBan.DiaChi
			from VatPham,NguoiBan,Tinh_Thanh,TheLoai
			where VatPham.MaNB = NguoiBan.MaNB
				and NguoiBan.MaTinhThanh = Tinh_Thanh.MaTinhThanh
				and VatPham.MaTL = TheLoai.MaTL and TheLoai.MaTL = @MaDM
	end
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[LayHinhAnh]    Script Date: 6/19/2020 10:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[LayHinhAnh](@MaVP int)
returns @BangLink table(
	Link varchar(max)
)as begin
	insert into @BangLink 
		select Link 
		from VatPham,HinhAnh_VatPham,HinhAnh
		where VatPham.MaVP = HinhAnh_VatPham.MaVatPham and
		HinhAnh_VatPham.MaHinhAnh = HinhAnh.MaHinhAnh
		and VatPham.MaVP = @MaVP
	return	
end
GO
/****** Object:  UserDefinedFunction [dbo].[LayThongTinTaiKhoan]    Script Date: 6/19/2020 10:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[LayThongTinTaiKhoan](@sdt nchar(50))
returns @BangChiTiet table(
	SDT nchar(50),MatKhau nchar(100),LoaiTK int,NgayTao datetime,HoTen varchar(500), Email nchar(500),
	QueQuan nvarchar(max),GioiTinh nvarchar(100),AnhDaiDien nvarchar(max),NgaySinh datetime
)as begin		
		insert into @BangChiTiet
			select TaiKhoan.SDT,MatKhau,LoaiTK,NgayTao,HoTen,Email,
					QueQuan,GioiTinh,AnhDaiDien,NgaySinh
			from TaiKhoan left join ThongTinTaiKhoan on TaiKhoan.SDT = ThongTinTaiKhoan.SDT
			where TaiKhoan.SDT = @sdt
		return
end
GO
/****** Object:  UserDefinedFunction [dbo].[ThongTinVatPham]    Script Date: 6/19/2020 10:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[ThongTinVatPham](@MaVP int)
returns @BangChiTiet table(
	MaVP int,TenVP nvarchar(500),HoTen nvarchar(500),SDT varchar(50), TenTinhThanh nvarchar(500),
	MoTa nvarchar(max), TinhTrang nvarchar(500),GiaTien bigint,
	TenTL nvarchar(500),NgayDang int,LinkHinhAnh varchar(Max),ChatLuong int,
	DiaChi nvarchar(500),MaTL int
) as begin
	if(@MaVP = 0)
	begin
		insert into @BangChiTiet
			select MaVP,TenVP,HoTen,SDT,TenTinhThanh,MoTa,TinhTrang,GiaTien,TenTL,
			DATEDIFF(HOUR,NgayDang,GETDATE()),LinkHinhAnh,ChatLuong,NguoiBan.DiaChi,VatPham.MaTL
			from VatPham,NguoiBan,Tinh_Thanh,TheLoai
			where VatPham.MaNB = NguoiBan.MaNB
				and NguoiBan.MaTinhThanh = Tinh_Thanh.MaTinhThanh
				and VatPham.MaTL = TheLoai.MaTL
	end
	else
	begin
		insert into @BangChiTiet
			select MaVP,TenVP,HoTen,SDT,TenTinhThanh,MoTa,TinhTrang,GiaTien,TenTL,
			DATEDIFF(HOUR,NgayDang,GETDATE()),LinkHinhAnh,ChatLuong,NguoiBan.DiaChi,VatPham.MaTL
			from VatPham,NguoiBan,Tinh_Thanh,TheLoai
			where VatPham.MaNB = NguoiBan.MaNB
				and NguoiBan.MaTinhThanh = Tinh_Thanh.MaTinhThanh
				and VatPham.MaTL = TheLoai.MaTL and MaVP = @MaVP
	end
	return
end
GO
/****** Object:  UserDefinedFunction [dbo].[VatPhamDaDangCua]    Script Date: 6/19/2020 10:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[VatPhamDaDangCua] (@sdt nchar(50))
returns @BangChiTiet table(
	MaVP int,TenVP nvarchar(500),GiaTien bigint,ThoiGian int,LinkHinhAnh varchar(max),KiemDuyet int,NgungBan int
)as begin
	insert into @BangChiTiet
			select MaVP,TenVP,GiaTien,
			DATEDIFF(HOUR,NgayDang,GETDATE()),LinkHinhAnh,KiemDuyet,NgungBan
			from VatPham join NguoiBan on VatPham.MaNB = NguoiBan.MaNB
			where KiemDuyet = 1 and NgungBan = 0 and SDT = @sdt							
	return
end
GO
/****** Object:  Table [dbo].[BaoXau]    Script Date: 6/19/2020 10:20:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaoXau](
	[SDT] [nchar](50) NULL,
	[MaVP] [int] NULL,
	[LyDo] [nvarchar](500) NULL,
	[GhiChu] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DatMua]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatMua](
	[MaNM] [int] NULL,
	[MaVP] [int] NULL,
	[ThoiGian] [datetime] NULL,
	[GhiChu] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HinhAnh]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HinhAnh](
	[MaHinhAnh] [int] IDENTITY(1,1) NOT NULL,
	[Link] [nvarchar](max) NULL,
 CONSTRAINT [PK_HinhAnh] PRIMARY KEY CLUSTERED 
(
	[MaHinhAnh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HinhAnh_VatPham]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HinhAnh_VatPham](
	[MaVatPham] [int] NULL,
	[MaHinhAnh] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NguoiBan]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NguoiBan](
	[MaNB] [int] IDENTITY(1,1) NOT NULL,
	[MaTinhThanh] [int] NULL,
	[SDT] [nchar](50) NULL,
	[HoTen] [nvarchar](500) NULL,
	[DiaChi] [nvarchar](500) NULL,
 CONSTRAINT [PK_NguoiBan] PRIMARY KEY CLUSTERED 
(
	[MaNB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NguoiMua]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NguoiMua](
	[MaNM] [int] IDENTITY(1,1) NOT NULL,
	[TenNM] [nvarchar](500) NULL,
	[Email] [nchar](500) NULL,
	[DiaChi] [nvarchar](500) NULL,
	[SDT] [nchar](50) NULL,
 CONSTRAINT [PK_NguoiMua] PRIMARY KEY CLUSTERED 
(
	[MaNM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNV] [int] NULL,
	[ChucVu] [nvarchar](200) NULL,
	[TenNV] [nvarchar](500) NULL,
	[SDT] [nchar](50) NULL,
	[DiaChi] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaiKhoan]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaiKhoan](
	[SDT] [nchar](50) NOT NULL,
	[MatKhau] [nchar](100) NULL,
	[LoaiTK] [int] NULL,
	[NgayTao] [datetime] NULL,
 CONSTRAINT [PK_TaiKhoan] PRIMARY KEY CLUSTERED 
(
	[SDT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TheLoai]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TheLoai](
	[MaTL] [int] NOT NULL,
	[TenTL] [nvarchar](200) NULL,
	[Icon] [nchar](200) NULL,
 CONSTRAINT [PK_TheLoai] PRIMARY KEY CLUSTERED 
(
	[MaTL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThongBao]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThongBao](
	[MaTB] [int] IDENTITY(1,1) NOT NULL,
	[HinhAnh] [nvarchar](max) NULL,
	[NoiDungTB] [nvarchar](max) NULL,
	[SDT] [nchar](50) NULL,
	[DaDoc] [int] NULL,
	[Link] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThongTinTaiKhoan]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThongTinTaiKhoan](
	[HoTen] [nvarchar](500) NULL,
	[Email] [nchar](500) NULL,
	[QueQuan] [nvarchar](max) NULL,
	[GioiTinh] [nvarchar](100) NULL,
	[AnhDaiDien] [nvarchar](max) NULL,
	[NgaySinh] [datetime] NULL,
	[SDT] [nchar](50) NOT NULL,
 CONSTRAINT [PK_ThongTinTaiKhoan] PRIMARY KEY CLUSTERED 
(
	[SDT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tinh_Thanh]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tinh_Thanh](
	[MaTinhThanh] [int] IDENTITY(1,1) NOT NULL,
	[TenTinhThanh] [nvarchar](500) NULL,
 CONSTRAINT [PK_Tinh_Thanh] PRIMARY KEY CLUSTERED 
(
	[MaTinhThanh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VatPham]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VatPham](
	[MaVP] [int] IDENTITY(1,1) NOT NULL,
	[MaNB] [int] NULL,
	[TenVP] [nvarchar](500) NULL,
	[MoTa] [nvarchar](max) NULL,
	[TinhTrang] [nvarchar](500) NULL,
	[GiaTien] [bigint] NULL,
	[MaTL] [int] NULL,
	[LinkHinhAnh] [nvarchar](max) NULL,
	[NgayDang] [datetime] NULL,
	[ChatLuong] [int] NULL,
	[KiemDuyet] [int] NULL,
	[NgungBan] [int] NULL,
 CONSTRAINT [PK_VatPham] PRIMARY KEY CLUSTERED 
(
	[MaVP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[YeuThich]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[YeuThich](
	[SDT] [nchar](50) NOT NULL,
	[MaVP] [int] NOT NULL,
	[ThoiGian] [datetime] NULL,
 CONSTRAINT [PK_YeuThich] PRIMARY KEY CLUSTERED 
(
	[SDT] ASC,
	[MaVP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[HinhAnh] ON 

INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1, N'cdbc32092cab48f5ab1931a9a63ef8c8-2664313748547256462.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (2, N'449e9da4d9e0b3a71429a3fd3db50869-2664313776549386617.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (3, N'8bff6da86831b95ed2fc17e97c596298-2664313776877225109.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (4, N'f4aa540b575197bf34933bfaf56ab7cd-2664313776357065877.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (5, N'5ef3d3be5b036c3df58e7b619ee82e63-2664313776163420687.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (6, N'3e0a7ca614672eafdf58802e5a50a94c-2664313776180314254.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (7, N'a5b47f359c397d4d251de4ca7beb327b-2664327257026314332.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (8, N'33f491399f2b0baa5b22ddb1d10398db-2664327258231790167.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (9, N'b51b1d34e3ea4428161fd704c41f45bf-2637139691732468494.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (10, N'590d3e55dc8362637ef2304fd57d69d1-2637139692235332355.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (11, N'eef553e73250244d0f4a60655febeec0-2661341230590459209.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (12, N'9e6a4145f76c428cb5c82f744840b71c-2661341230548000693.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (13, N'Huan-Hoa-Hong.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (14, N'anh-chup-man-hinh-2020-04-28-luc-102615-15880443929471147001923.png')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (15, N'9312202931264221174759993229631367243366400n-1-1588058771453466298643-crop-15880588781741556495041.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (16, N'3caa6da88aefbf363b8add78ee290dbd-2649075284507425907.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (17, N'72bae5691aeafc2d49e3803bc88d15a4-2649075295383680528.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (18, N'2c97566f5bae954ef5e8bdec154a4013-2649075310002393904.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (19, N'6d72e0b3368da3aa54088fe3ba2872a4-2649075314851271472.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (20, N'ea2674c2950a95c404e566d216276aba-2649075320696994931.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (21, N'cf11758aa91c49d8a6a7892ba4ad2ad6-2649075338016093712.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (22, N'2c74c67c58d2d21d71c8d9983d11800c-2649075349307553296.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (23, N'30de3e75f6fa54d64b8e9c0371293e86-2664473232527827801.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (24, N'8801a5cf584a64610ecaf0b07fbe5aaa-2664473233654014599.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (25, N'332ff0f81e82cc05e2aba335edd2ea3e-2664473234477669300.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (26, N'92a708fd4287143edc5bddfd143d2f9f-2664473233702570045.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (27, N'du-hoc-uc-nganh-ky-su-phan-mem.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (28, N'du-hoc-uc-nganh-ky-su-phan-mem-1.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (29, N'1652209578.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (30, N'1639004928.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (31, N'1621958290.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (32, N'17837fca2f12f0cf462b8f6a2ccae56b-2664514497881762801.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (33, N'a750ae2ed0a272525deb3759d2fe3167-2664514499020708408.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (34, N'7513fe1638c8faa0929c736d422f5bd9-2664514497512607698.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (35, N'1d39545b0b5ac92ee1dbc4b66e9855dd-2664514497743925313.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (36, N'e46225c5caae013a0ce563cf84e374c7-2664514497745707034.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (37, N'6f0ee97f4fe607720349ad80cf91ee57-2664514497625909128.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (38, N'921e198170c1ebbbc1aec991ed9f9111-2664514497561590441.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (39, N'9165097d3de31ce07d2b209c790302ed-2664509016278025364.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (40, N'277ff65160dda0a9379411a1f6675a3b-2664509015876751189.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (41, N'a7d8cf104636b213af2e0125f87991de-2664509016033889548.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (42, N'batma.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (43, N'batma1.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (44, N'batma2.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (45, N'6a6f6ac956cfff07d456bb68f9fb88e4-2664420218180526593.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (46, N'669b1db41c41d7b047b791edb5a0e35b-2664420217643697019.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (47, N'aa88247b0dc77893c63e449cfe57b0b9-2664420217878471169.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (48, N'9cfab89ad1ad26943be68c8e232ee407-2664420217526084097.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (49, N'26b7990d8917f5299bcae03fbf6357b3-2664509620079186855.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (50, N'2c287658d29a9cb6b6e59210035bce87-2664509619106042791.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (51, N'3eaebfcd192106e696e17350743ea0ce-2664509618682871857.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (52, N'7ac8c014-8e57-430f-9f19-0be726995963.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (53, N'1d5b5f7e-166f-4df6-8403-7dd90393c772.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (54, N'd2843e1b-8eeb-4227-81cc-0e6e76bf2f57.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (55, N'f83960c3-eebc-4027-8670-268203b05d8d.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (56, N'81121178-29f5-41b5-8362-9af5babe4c54.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (57, N'9cdb168d-3055-4b13-9913-b88b24a7c834.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (58, N'ef37076f-002d-4258-9d38-d4c395760328.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (59, N'fbe15849-d327-4ba8-ba39-0e090c2fc01e.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (60, N'089b3ae4-9792-4148-8697-ffa7e997fbb3.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (61, N'd031cb9d-1585-4d99-9528-689b323c9bf2.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (62, N'ad6968dd-1796-4ef7-a78d-1228e7417267.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (63, N'46d50bfc-8f3d-4d3c-bba6-7fba87390da7.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (64, N'755c59fa-523e-4070-ada8-97ffa51dbc3e.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (65, N'7e999fea-72de-4c3c-8907-341c110f689a.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (66, N'da97e267-f355-4e30-9a32-334100ad7f99.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (67, N'936018a3-67eb-4c4d-bf92-ecfcad5a2aa4.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1065, N'9e6f34a3-000b-4c0f-b67d-2f3d1c984a8c.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1066, N'cc3ed4ae-ba8d-47db-9515-668292c10ade.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1067, N'e49b1cfc-a5e7-4dfc-87a6-ab9bf39d920b.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1068, N'1c3db466-5b02-4e11-9c18-41c2e9c69929.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1069, N'\b8f71ec1-08a9-45be-a4b3-707d8d30e162.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1070, N'\49d13453-fbed-4cdf-bf19-5b76ef5d201d.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1071, N'\181069b0-7944-4a93-b05c-7fb8cd17846d.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1072, N'\22d8e371-30bc-4d6a-b999-705899ee890a.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1073, N'\4d161384-003b-4c5b-b8cb-29552b486cd0.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1074, N'\9cdc21e3-c8a9-405d-aa91-14e4e2a5591c.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1075, N'\51aa4942-90cb-46a1-bfc3-8aacbd8c5560.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1076, N'\f400a55e-2e25-4c30-a603-ba44264f4f74.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1077, N'\78a8d8b1-ef3f-476e-8342-36c1f020ddb7.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1078, N'\7b589c39-f3a4-4001-a59f-c0ea37cc8f7c.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1079, N'\9c8c02bd-183b-4b21-9ba7-5e8cc1020eda.jpg')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1080, N'\d1403691-f791-4297-8409-a084d0074463.png')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1081, N'\d96cfea2-a9c8-44fc-9636-80d9e0c7ce9e.png')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1082, N'\7f5ae7fa-8b8a-4201-9d20-625d35b09d93.png')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1083, N'\57b4fd45-226e-4801-9a7d-a7256c842db4.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1084, N'\852ec364-7688-45ea-9744-f58deee35026.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1085, N'\aaa6a084-6b1f-4731-b505-35ac833b4479.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1086, N'\aa04e2dd-b12f-4f5c-a3e2-3ae7e7535b85.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1087, N'\fd07278d-dc5c-4f14-b918-852f7837e774.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1088, N'\da005daa-fea0-489a-befd-d59e62c7b1fc.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1089, N'\86c632ef-90e4-4b6e-ac05-414999ab7f07.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1090, N'\a76e49ca-4527-4847-bf8d-dbc5604a30f4.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1091, N'\a330e760-0d2f-423f-9e4a-4a5494a0ecbd.PNG')
INSERT [dbo].[HinhAnh] ([MaHinhAnh], [Link]) VALUES (1092, N'\6e43ecce-b848-47ae-866d-c52b346b9d92.PNG')
SET IDENTITY_INSERT [dbo].[HinhAnh] OFF
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1, 1)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1, 2)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1, 3)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1, 4)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1, 5)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1, 6)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (2, 7)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (2, 8)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (3, 9)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (3, 10)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (3, 11)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (3, 12)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (4, 13)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (4, 14)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (4, 15)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (5, 16)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (5, 17)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (5, 18)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (5, 19)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (5, 20)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (5, 21)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (5, 22)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (6, 23)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (6, 24)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (6, 25)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (6, 26)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (7, 27)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (7, 28)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (8, 29)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (8, 30)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (8, 31)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (9, 32)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (9, 33)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (9, 34)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (9, 35)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (9, 36)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (9, 37)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (9, 38)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (10, 39)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (10, 40)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (10, 41)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (11, 42)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (11, 43)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (11, 44)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (12, 45)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (12, 46)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (12, 47)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (12, 48)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (13, 49)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (13, 50)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (13, 51)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (14, 52)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (14, 53)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (14, 54)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (14, 55)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (15, 56)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (15, 57)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (15, 58)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (16, 59)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (16, 60)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (16, 61)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (16, 62)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (16, 63)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1018, 1065)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1018, 1066)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1018, 1067)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1018, 1068)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1019, 1069)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1019, 1070)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1019, 1071)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1019, 1072)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1019, 1073)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1020, 1074)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1020, 1075)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1020, 1076)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1022, 1080)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1022, 1081)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1022, 1082)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1022, 1083)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1022, 1084)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1022, 1085)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1022, 1086)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1022, 1087)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1023, 1088)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1023, 1089)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1023, 1090)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1023, 1091)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (1023, 1092)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (17, 64)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (18, 65)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (18, 66)
INSERT [dbo].[HinhAnh_VatPham] ([MaVatPham], [MaHinhAnh]) VALUES (18, 67)
SET IDENTITY_INSERT [dbo].[NguoiBan] ON 

INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (1, 24, N'1234567891                                        ', N'Bùi Trung Tú', N'Bắc Từ Liêm')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (2, 24, N'1234567894                                        ', N'Nguyễn Thị Thu Hà', N'Đan Phượng')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (3, 63, N'1234567895                                        ', N'Bùi Xuân Huấn', N'Mù Cang Chải')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (4, 31, N'1234567893                                        ', N'Văn Lâm Auto', N'Quận 3')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (5, 24, N'1234567810                                        ', N'Lê Minh Khôi', N'Ba Đình')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (6, 21, N'1234567892                                        ', N'Lê Văn Việt', N'An Khê')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (7, 1, N'123456799                                         ', N'Nguyễn Kiều Linh', N'Châu Thành')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (8, 31, N'1234567895                                        ', N'Công Ty BĐS Hải Long', N'Quận 1')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (9, 31, N'1234567896                                        ', N'Huy Ngọc Bike', N'Quận 1')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (10, 62, N'1234567897                                        ', N'Hoàng Nghĩa Long', N'Vĩnh Yên')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (11, 45, N'1234567898                                        ', N'Phan Duy Anh', N'Tuy Hòa')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (12, 31, N'1234567895                                        ', N'Huấn Hoa Hồng', N'Quận 10')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (13, 1, N'1234567893                                        ', N'Bùi Trung Tú', N'Bắc Từ Liêm')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (14, 4, N'1234567899                                        ', N'Công Ty TNHH Long Châu', N'Yên Dũng')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (15, 4, N'1234567899                                        ', N'Công Ty TNHH Long Châu', N'Yên Dũng')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (16, 31, N'1234567810                                        ', N'Khôi Kháu Khỉnh', N'Quận 1')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (17, 31, N'1234567893                                        ', N'Phan Lê food', N'Quận 8')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (1017, 24, N'1234567810                                        ', N'Công Ty CP Thương Mại Và Công Nghệ Đất Việt', N'Hoài Đức')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (1018, 24, N'17150012                                          ', N'Nguyễn Văn Long', N'Hoàn Kiếm')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (1019, 24, N'1234567810                                        ', N'Lê Minh Khôi', N'Đường Hào Nam, Phường Ô Chợ Dừa, Quận Đống Đa')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (1021, 24, N'1234567893                                        ', N'Bùi Trung Tú', N'Hoài Đức')
INSERT [dbo].[NguoiBan] ([MaNB], [MaTinhThanh], [SDT], [HoTen], [DiaChi]) VALUES (1022, 17, N'1234567893                                        ', N'Bùi Trung Tú', N'Yên Dũng')
SET IDENTITY_INSERT [dbo].[NguoiBan] OFF
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'12321321                                          ', N'1                                                                                                   ', 0, CAST(N'2020-05-17T00:04:29.460' AS DateTime))
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1233213243                                        ', N'1                                                                                                   ', 0, CAST(N'2020-05-13T12:19:05.353' AS DateTime))
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567810                                        ', N'1                                                                                                   ', 1, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567891                                        ', N'1                                                                                                   ', 1, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567892                                        ', N'1                                                                                                   ', 0, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567893                                        ', N'1                                                                                                   ', 0, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567894                                        ', N'1                                                                                                   ', 0, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567895                                        ', N'1                                                                                                   ', 0, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567896                                        ', N'1                                                                                                   ', 0, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567897                                        ', N'1                                                                                                   ', 1, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567898                                        ', N'1                                                                                                   ', 1, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'1234567899                                        ', N'1                                                                                                   ', 0, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'123456799                                         ', N'1                                                                                                   ', 0, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'17150012                                          ', N'1                                                                                                   ', 0, NULL)
INSERT [dbo].[TaiKhoan] ([SDT], [MatKhau], [LoaiTK], [NgayTao]) VALUES (N'88888888                                          ', N'1                                                                                                   ', 2, CAST(N'2020-05-26T16:51:14.670' AS DateTime))
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (1, N'Bất động sản', N'fa fa-home                                                                                                                                                                                              ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (2, N'Điện tử và đồ gia dụng', N'fa fa-laptop                                                                                                                                                                                            ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (3, N'Nội thất', N'fa fa-wheelchair                                                                                                                                                                                        ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (4, N'Du lịch, Dịch vụ', N'fa fa-wrench                                                                                                                                                                                            ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (5, N'Trẻ em', N'fa fa-child                                                                                                                                                                                             ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (6, N'Thú cưng', N'fa fa-paw                                                                                                                                                                                               ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (7, N'Sách và sở thích', N'fa fa-book                                                                                                                                                                                              ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (8, N'Thời trang', N'fa fa-black-tie                                                                                                                                                                                         ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (9, N'Đồ ăn', N'fa fa-spoon                                                                                                                                                                                             ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (10, N'Xe Cộ', N'fa fa-car                                                                                                                                                                                               ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (11, N'Việc làm', N'fa fa-smile-o                                                                                                                                                                                           ')
INSERT [dbo].[TheLoai] ([MaTL], [TenTL], [Icon]) VALUES (12, N'Nông nghiệp', N'fa fa-pagelines                                                                                                                                                                                         ')
SET IDENTITY_INSERT [dbo].[ThongBao] ON 

INSERT [dbo].[ThongBao] ([MaTB], [HinhAnh], [NoiDungTB], [SDT], [DaDoc], [Link]) VALUES (24, N'9312202931264221174759993229631367243366400n-1-1588058771453466298643-crop-15880588781741556495041.jpg', N'Có người thích mặt hàng của bạn', N'1234567895                                        ', 0, N'/ChiTietVatPham/4')
INSERT [dbo].[ThongBao] ([MaTB], [HinhAnh], [NoiDungTB], [SDT], [DaDoc], [Link]) VALUES (25, N'9312202931264221174759993229631367243366400n-1-1588058771453466298643-crop-15880588781741556495041.jpg', N'Có người thích sản phẩm của bạn', N'1234567895                                        ', 0, N'/ChiTietVatPham/4')
INSERT [dbo].[ThongBao] ([MaTB], [HinhAnh], [NoiDungTB], [SDT], [DaDoc], [Link]) VALUES (29, N'du-hoc-uc-nganh-ky-su-phan-mem.jpg', N'Có người thích sản phẩm của bạn', N'1234567892                                        ', 0, N'/ChiTietVatPham/7')
INSERT [dbo].[ThongBao] ([MaTB], [HinhAnh], [NoiDungTB], [SDT], [DaDoc], [Link]) VALUES (32, N'a5b47f359c397d4d251de4ca7beb327b-2664327257026314332.jpg', N'Có người thích sản phẩm của bạn', N'1234567894                                        ', 0, N'/ChiTietVatPham/2')
INSERT [dbo].[ThongBao] ([MaTB], [HinhAnh], [NoiDungTB], [SDT], [DaDoc], [Link]) VALUES (26, N'partner.png', N'Tải lên ngay mặt hàng đầu tiên của bạn', N'12321321                                          ', 0, N'/DangTinBan/12321321 ')
INSERT [dbo].[ThongBao] ([MaTB], [HinhAnh], [NoiDungTB], [SDT], [DaDoc], [Link]) VALUES (27, N'3caa6da88aefbf363b8add78ee290dbd-2649075284507425907.jpg', N'Có người thích sản phẩm của bạn', N'1234567893                                        ', 0, N'/ChiTietVatPham/5')
INSERT [dbo].[ThongBao] ([MaTB], [HinhAnh], [NoiDungTB], [SDT], [DaDoc], [Link]) VALUES (30, N'du-hoc-uc-nganh-ky-su-phan-mem.jpg', N'Có người thích sản phẩm của bạn', N'1234567892                                        ', 0, N'/ChiTietVatPham/7')
INSERT [dbo].[ThongBao] ([MaTB], [HinhAnh], [NoiDungTB], [SDT], [DaDoc], [Link]) VALUES (28, N'3caa6da88aefbf363b8add78ee290dbd-2649075284507425907.jpg', N'Có người thích sản phẩm của bạn', N'1234567893                                        ', 0, N'/ChiTietVatPham/5')
INSERT [dbo].[ThongBao] ([MaTB], [HinhAnh], [NoiDungTB], [SDT], [DaDoc], [Link]) VALUES (31, N'batma1.jpg', N'Có người thích sản phẩm của bạn', N'1234567897                                        ', 0, N'/ChiTietVatPham/11')
SET IDENTITY_INSERT [dbo].[ThongBao] OFF
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Nguyễn Phan Hà', N'dsa@gmail.com                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ', N'Hà Nội', N'Nam', N'12321321.jpg', CAST(N'1998-06-30T00:00:00.000' AS DateTime), N'12321321                                          ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Đinh Thị Thanh Thúy', N'thuythu@gmail.com                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ', NULL, NULL, NULL, NULL, N'1233213243                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'1234567810                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'1234567891                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'1234567892                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Test hệ thống', N'test@gmail.com                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ', N'Hà Nội', N'Nam', N'1234567893.jpg', CAST(N'1998-06-30T00:00:00.000' AS DateTime), N'1234567893                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'1234567894                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'1234567895                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'1234567896                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'1234567897                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'1234567898                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'1234567899                                        ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Chưa Có', N'Chưa Có                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ', N'Chưa Có', N'Chưa Có', N'user.jpg', NULL, N'123456799                                         ')
INSERT [dbo].[ThongTinTaiKhoan] ([HoTen], [Email], [QueQuan], [GioiTinh], [AnhDaiDien], [NgaySinh], [SDT]) VALUES (N'Đinh Văn Long', N'longdv@gmail.com                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ', N'Tây tựu - Bắc Từ Liêm - Hà Nội', N'Nam', N'user.jpg', CAST(N'1998-01-01T00:00:00.000' AS DateTime), N'17150012                                          ')
SET IDENTITY_INSERT [dbo].[Tinh_Thanh] ON 

INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (1, N'An Giang')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (2, N'Bà Rịa - Vũng Tàu')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (3, N'Đà Nẵng')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (4, N'Bắc Giang')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (5, N'Bắc Kạn')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (6, N'Bắc Ninh')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (7, N'Bến Tre')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (8, N'Bình Dương')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (9, N'Bình Định')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (10, N'Bình Phước')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (11, N'Bình Thuận')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (12, N'Cà Mau')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (13, N'Cao Bằng')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (14, N'Cần Thơ')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (15, N'Đà Nẵng')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (16, N'Đắk Lắk')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (17, N'Đắk Nông')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (18, N'Đồng Nai')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (19, N'Đồng Tháp')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (20, N'Điện Biên')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (21, N'Gia Lai')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (22, N'
Hà Giang')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (23, N'Hà Nam')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (24, N'Hà Nội')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (25, N'Hà Tĩnh')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (26, N'Hải Dương')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (27, N'Hải Phòng')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (28, N'Hòa Bình')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (29, N'Hậu Giang')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (30, N'Hưng Yên')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (31, N'Hồ Chí Minh')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (32, N'Khánh Hòa')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (33, N'Kiên Giang')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (34, N'Kon Tum')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (35, N'Lai Châu')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (36, N'Lào Cai')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (37, N'Lạng Sơn')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (38, N'Lâm Đồng')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (39, N'Long An')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (40, N'Nam Định')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (41, N'Nghệ An')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (42, N'Ninh Bình')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (43, N'Ninh Thuận')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (44, N'Phú Thọ')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (45, N'Phú Yên')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (46, N'Quảng Bình')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (47, N'Quảng Nam')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (48, N'Quảng Ngãi')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (49, N'Quảng Ninh')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (50, N'Quảng Trị')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (51, N'Sóc Trăng')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (52, N'Sơn La')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (53, N'Tây Ninh')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (54, N'Thái Bình')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (55, N'Thái Nguyên')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (56, N'Thanh Hóa')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (57, N'Thừa Thiên - Huế')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (58, N'Tiền Giang')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (59, N'Trà Vinh')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (60, N'Tuyên Quang')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (61, N'Vĩnh Long')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (62, N'Vĩnh Phúc')
INSERT [dbo].[Tinh_Thanh] ([MaTinhThanh], [TenTinhThanh]) VALUES (63, N'Yên Bái')
SET IDENTITY_INSERT [dbo].[Tinh_Thanh] OFF
SET IDENTITY_INSERT [dbo].[VatPham] ON 

INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (1, 1, N'BMW 330i 2019 M Sport', N'Xe chưa va chạm bao giờ								Key less-go, led nội thất, camera, đá cóp, ....
								Bao check hãng, lỗi tặng xe', N'Xe lướt', 1030000000, 10, N'cdbc32092cab48f5ab1931a9a63ef8c8-2664313748547256462.jpg', CAST(N'2020-04-30T00:00:00.000' AS DateTime), 4, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (2, 2, N'Phốc hươu', N'Chó đực 2 tháng tuổi mới xổ giun , chưa chích ngừa , chó khôn ngoan , khỏe mạnh ... Giá 1,2 triệu . còn tín - còn chó', N'Khỏe mạnh', 1200000, 6, N'a5b47f359c397d4d251de4ca7beb327b-2664327257026314332.jpg', CAST(N'2020-01-01T00:00:00.000' AS DateTime), 4, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (3, 2, N'Phốc sóc 5 tháng', N'Chó phốc sóc đực 5 th tuổi
Khoẻ mạnh, ăn uống tốt
Đã tiêm phòng đủ
Đang thời kỳ thay lông nên hơi xấu mã chứ tháng nữa, lông dày đẹp', N'Khỏe mạnh', 2600000, 6, N'b51b1d34e3ea4428161fd704c41f45bf-2637139691732468494.jpg', CAST(N'2020-03-04T00:00:00.000' AS DateTime), 4, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (4, 3, N'Đệ nhất kiếm tiền Online', N'Cuốn sách viết theo kiểu kể về kinh nghiệm bán hàng onine của anh ta, không theo một trình tự hành văn nào. Đặc biệt, sách có nhiều nội dung kiểu bịa đặt, khó tin.', N'Mới', 799000, 7, N'9312202931264221174759993229631367243366400n-1-1588058771453466298643-crop-15880588781741556495041.jpg', CAST(N'2020-04-03T00:00:00.000' AS DateTime), 5, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (5, 4, N'Rolls Royce Ghost', N'Chả biết viết cái gì', N'Xe lướt', 10200000000, 10, N'3caa6da88aefbf363b8add78ee290dbd-2649075284507425907.jpg', CAST(N'2020-01-04T00:00:00.000' AS DateTime), 5, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (6, 5, N'MẬN HẬU SƠN LA', N'MẬN HẬU SƠN LA

Nhà mình có mấy vườn mận đã đến lúc thu hoạch, Hiện tìm các bạn nhập số lượng về bán, MẬN nhà trồng nên rất đảm bảo nha.

Giá: 50k/kg
Ai lấy buôn thì thoải mái nha, số lượng không hạn chế.', N'Mới', 50000, 9, N'30de3e75f6fa54d64b8e9c0371293e86-2664473232527827801.jpg', CAST(N'2020-04-01T00:00:00.000' AS DateTime), 4, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (7, 6, N'Kỹ sư phần mềm', N'Vừa mới tốt nghiệp, cho gì làm lấy', N'Mới', 8000000, 11, N'du-hoc-uc-nganh-ky-su-phan-mem.jpg', CAST(N'2020-02-02T00:00:00.000' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (8, 7, N'Xe đẩy trẻ em', N'Còn ít xe đẩy 1 chiều 3 tư thế ngồi, nằm, ngả mới 100 %. xe đầy đủ mái che nắng mưa khóa bánh an toàn khi không dùng có thể gấp gọn gàng cất đi . xe nhỏ gọn rất thuận tiện cho việc mang đi du lịch hay dã ngoại ngoài trời mà bố mẹ không phải no cảnh bồng bế nóng bức mệt mỏi giá chỉ 490k .', N'Mới', 490000, 5, N'1652209578.jpg', CAST(N'2020-02-07T00:00:00.000' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (9, 8, N'NHÀ ĐÊ TÔ HOÀNG - NỘI THẤT ĐẸP, TIỆN NGHI HOÀN HẢO
', N'Vị trí:nhà cách đường ô tô 30m, ngõ 201 xe máy tránh thông với ngõ Đỗ Thuận. Đi đường nào cũng tiện. Cách ngã tư Phố Huế Đại Cồ Việt vài bước chân.Nhà 5 tầng, thiết kế rất hợp lý, mỗi tầng 1 phòng ngủ và 1 wc rất rộng rãi. Nhà có ban công và mặt tiền rộng nên rất thoáng, sáng.Tầng 5 thiết kế 1 phòng đọc sách và 1 khu tiểu cảnh xinh đẹp để thư giãn, khách vào sẽ rất yêu.', N'Mới xây dựng', 3300000000, 1, N'17837fca2f12f0cf462b8f6a2ccae56b-2664514497881762801.jpg', CAST(N'2020-01-30T00:00:00.000' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (10, 9, N'Xe địa hình khung nhôm giá rẻ', N'Xe khung nhôm cỡ vành 26 ,đề 21 tốc độ .xe mới 100% .bảo hành 1 năm.', N'Mới', 2800000, 10, N'9165097d3de31ce07d2b209c790302ed-2664509016278025364.jpg', CAST(N'2020-03-30T00:00:00.000' AS DateTime), 4, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (11, 10, N'Dịch vụ tang lễ Hoàng Long', N'Chúng tôi chuyên Tổ chức tang lễ tại nhà riêng , thực hiện đầy đủ các thủ tục của tang lễ , chất lượng phục vụ cao . Giá cả hợp lý, tổ chức chuyên nghiệp loại bỏ bớt các thủ tục rườm rà tiết kiệm thời gian và chi phí cho gia đình nhưng vẫn giữ được nét truyền thống căn bản và cần thiết', N'Mới thành lập', 9800000, 4, N'batma1.jpg', CAST(N'2020-02-12T00:00:00.000' AS DateTime), 2, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (12, 11, N'Tủ đông 280 lít', N'Cửa hàng thanh li tủ đông 2 ngăn. 1 đông 1 mát
Dung tích 280 lít
Tủ cam kết còn nguyên bản 100%
Dàn lạnh bằng đồng siêu bền, tiết kiện điện, không sợ hao gas', N'Mới 95%', 3700000, 2, N'6a6f6ac956cfff07d456bb68f9fb88e4-2664420218180526593.jpg', CAST(N'2020-04-03T00:00:00.000' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (13, 1, N'Bộ bàn ghế 6 món gỗ cẩm vân', N'Liên hệ Ô Ngọc 128 Chùa Thông - Sơn Tây - Hà Nội', N'Đã sử dụng', 22000000, 3, N'26b7990d8917f5299bcae03fbf6357b3-2664509620079186855.jpg', CAST(N'2020-03-08T00:00:00.000' AS DateTime), 4, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (14, 13, N'Bán diagram CSDL', N'test thử thôi
chả sao đau 
đm sợ vcl', N'Đã sử dụng', 100000, 11, N'7ac8c014-8e57-430f-9f19-0be726995963.PNG', CAST(N'2020-05-03T22:19:04.707' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (15, 14, N'Máy cày Belarus', N'Máy cày xách tay từ Belarus', N'Đã sử dụng', 100000000, 12, N'81121178-29f5-41b5-8362-9af5babe4c54.jpg', CAST(N'2020-05-03T23:00:22.850' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (16, 15, N'Máy tuốt lúa', N'Mới sử dụng 3 tháng, giá cả có thể thương lượng được', N'Đã sử dụng 3 tháng', 1200000, 12, N'fbe15849-d327-4ba8-ba39-0e090c2fc01e.jpg', CAST(N'2020-05-03T23:07:04.950' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (17, 16, N'Bán Honda CR V 2015 2.0', N'Xe gia đình sử dụng, bảo dưỡng theo lịch của hãng (có thể tham khảo lịch sử bảo dưỡng tại hãng honda). Xe còn rất mới, đi được 93K Km (còn tăng). Do nhu cầu lên đời nên cần bán.
', N'Đã sử dụng', 720000000, 10, N'755c59fa-523e-4070-ada8-97ffa51dbc3e.jpg', CAST(N'2020-05-03T23:33:52.487' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (18, 17, N'Ba rọi rút sườn nhập khẩu từ Nga', N'Ba rọi rút sườn có da nhập khẩu từ Nga đảm bảo ngon bổ rẻ. 140.000 vnđ / 1kg
', N'Mới', 140000, 9, N'7e999fea-72de-4c3c-8907-341c110f689a.jpg', CAST(N'2020-05-03T23:47:22.733' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (1018, 1017, N'Bể bơi thông minh - Intelipools', N'- Hệ thống lọc nước vô cùng gọn gàng và tiết kiệm năng lượng đảm bảo chất lượng nước thật sự trong vắt và tinh khiết
- Chế độ cao tốc với hệ thống vòi phun phụ trợ có thể dùng như một công cụ massage. 
- Hệ thống có thể tạo được dòng chảy đạt tốc độ 25 km/h, để người bơi có cảm giác đang bơi ngược dòng trên sông. ', N'Mới', 68000000, 5, N'9e6f34a3-000b-4c0f-b67d-2f3d1c984a8c.jpg', CAST(N'2020-05-09T22:02:48.573' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (1019, 1018, N'Bò úc, bò Mỹ nhập khẩu', N'Thịt bò được cắt, đóng gói theo yêu cầu của quý khách hàng
Liên hệ số hotline để được phục vụ tốt nhất
Đặc biệt ship trong ngày sau khi chốt đơn
', N'Tươi', 190000, 9, N'\b8f71ec1-08a9-45be-a4b3-707d8d30e162.jpg', CAST(N'2020-05-09T22:40:08.117' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (1020, 1019, N'Nhà Quận Đống Đa 50 mét vuông', N'Dự án: nhà ngõ 86 hào nam.
Thông tin chi tiết:
để mua ngay căn nhà ngõ 86 hào nam
diện tích 50m², 5m mặt', N'Đã sử dụng', 2300000000, 1, N'\9cdc21e3-c8a9-405d-aa91-14e4e2a5591c.jpg', CAST(N'2020-05-13T11:34:06.670' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (1022, 1021, N'Sinh Viên Làm Winform', N'Làm winform quản lý thư viện', N'Hoàn thành', 10000, 11, N'\d1403691-f791-4297-8409-a084d0074463.png', CAST(N'2020-06-17T23:46:11.803' AS DateTime), 3, 1, 0)
INSERT [dbo].[VatPham] ([MaVP], [MaNB], [TenVP], [MoTa], [TinhTrang], [GiaTien], [MaTL], [LinkHinhAnh], [NgayDang], [ChatLuong], [KiemDuyet], [NgungBan]) VALUES (1023, 1022, N'Test đăng bán', N'dsadsadsa', N'Chạy ổn', 1000000, 5, N'\da005daa-fea0-489a-befd-d59e62c7b1fc.PNG', CAST(N'2020-06-17T23:50:11.083' AS DateTime), 3, 1, 0)
SET IDENTITY_INSERT [dbo].[VatPham] OFF
INSERT [dbo].[YeuThich] ([SDT], [MaVP], [ThoiGian]) VALUES (N'1234567810                                        ', 2, CAST(N'2020-05-26T20:49:49.743' AS DateTime))
INSERT [dbo].[YeuThich] ([SDT], [MaVP], [ThoiGian]) VALUES (N'1234567810                                        ', 4, CAST(N'2020-05-16T23:46:37.310' AS DateTime))
INSERT [dbo].[YeuThich] ([SDT], [MaVP], [ThoiGian]) VALUES (N'1234567810                                        ', 7, CAST(N'2020-05-24T16:09:24.130' AS DateTime))
INSERT [dbo].[YeuThich] ([SDT], [MaVP], [ThoiGian]) VALUES (N'1234567810                                        ', 11, CAST(N'2020-05-24T23:00:23.793' AS DateTime))
INSERT [dbo].[YeuThich] ([SDT], [MaVP], [ThoiGian]) VALUES (N'1234567893                                        ', 5, CAST(N'2020-05-18T11:17:40.540' AS DateTime))
ALTER TABLE [dbo].[DatMua] ADD  CONSTRAINT [DF_DatMua_ThoiGian]  DEFAULT (getdate()) FOR [ThoiGian]
GO
ALTER TABLE [dbo].[TaiKhoan] ADD  CONSTRAINT [DF_TaiKhoan_NgayTao]  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[ThongBao] ADD  CONSTRAINT [DF_ThongBao_DaDoc]  DEFAULT ((0)) FOR [DaDoc]
GO
ALTER TABLE [dbo].[VatPham] ADD  CONSTRAINT [DF_VatPham_NgayDang]  DEFAULT (getdate()) FOR [NgayDang]
GO
ALTER TABLE [dbo].[VatPham] ADD  CONSTRAINT [DF_VatPham_ChatLuong]  DEFAULT ((3)) FOR [ChatLuong]
GO
ALTER TABLE [dbo].[VatPham] ADD  CONSTRAINT [DF_VatPham_KiemDuyet]  DEFAULT ((0)) FOR [KiemDuyet]
GO
ALTER TABLE [dbo].[VatPham] ADD  CONSTRAINT [DF_VatPham_NgungBan]  DEFAULT ((0)) FOR [NgungBan]
GO
ALTER TABLE [dbo].[YeuThich] ADD  CONSTRAINT [DF_YeuThich_ThoiGian]  DEFAULT (getdate()) FOR [ThoiGian]
GO
ALTER TABLE [dbo].[BaoXau]  WITH CHECK ADD  CONSTRAINT [FK_BaoXau_TaiKhoan] FOREIGN KEY([SDT])
REFERENCES [dbo].[TaiKhoan] ([SDT])
GO
ALTER TABLE [dbo].[BaoXau] CHECK CONSTRAINT [FK_BaoXau_TaiKhoan]
GO
ALTER TABLE [dbo].[BaoXau]  WITH CHECK ADD  CONSTRAINT [FK_BaoXau_VatPham] FOREIGN KEY([MaVP])
REFERENCES [dbo].[VatPham] ([MaVP])
GO
ALTER TABLE [dbo].[BaoXau] CHECK CONSTRAINT [FK_BaoXau_VatPham]
GO
ALTER TABLE [dbo].[DatMua]  WITH CHECK ADD  CONSTRAINT [FK_DatMua_NguoiMua] FOREIGN KEY([MaNM])
REFERENCES [dbo].[NguoiMua] ([MaNM])
GO
ALTER TABLE [dbo].[DatMua] CHECK CONSTRAINT [FK_DatMua_NguoiMua]
GO
ALTER TABLE [dbo].[DatMua]  WITH CHECK ADD  CONSTRAINT [FK_DatMua_VatPham] FOREIGN KEY([MaVP])
REFERENCES [dbo].[VatPham] ([MaVP])
GO
ALTER TABLE [dbo].[DatMua] CHECK CONSTRAINT [FK_DatMua_VatPham]
GO
ALTER TABLE [dbo].[HinhAnh_VatPham]  WITH CHECK ADD  CONSTRAINT [FK_HinhAnh_VatPham_HinhAnh] FOREIGN KEY([MaHinhAnh])
REFERENCES [dbo].[HinhAnh] ([MaHinhAnh])
GO
ALTER TABLE [dbo].[HinhAnh_VatPham] CHECK CONSTRAINT [FK_HinhAnh_VatPham_HinhAnh]
GO
ALTER TABLE [dbo].[HinhAnh_VatPham]  WITH CHECK ADD  CONSTRAINT [FK_HinhAnh_VatPham_VatPham] FOREIGN KEY([MaVatPham])
REFERENCES [dbo].[VatPham] ([MaVP])
GO
ALTER TABLE [dbo].[HinhAnh_VatPham] CHECK CONSTRAINT [FK_HinhAnh_VatPham_VatPham]
GO
ALTER TABLE [dbo].[NguoiBan]  WITH CHECK ADD  CONSTRAINT [FK_NguoiBan_TaiKhoan] FOREIGN KEY([SDT])
REFERENCES [dbo].[TaiKhoan] ([SDT])
GO
ALTER TABLE [dbo].[NguoiBan] CHECK CONSTRAINT [FK_NguoiBan_TaiKhoan]
GO
ALTER TABLE [dbo].[NguoiBan]  WITH CHECK ADD  CONSTRAINT [FK_NguoiBan_Tinh_Thanh] FOREIGN KEY([MaTinhThanh])
REFERENCES [dbo].[Tinh_Thanh] ([MaTinhThanh])
GO
ALTER TABLE [dbo].[NguoiBan] CHECK CONSTRAINT [FK_NguoiBan_Tinh_Thanh]
GO
ALTER TABLE [dbo].[NguoiMua]  WITH CHECK ADD  CONSTRAINT [FK_NguoiMua_TaiKhoan] FOREIGN KEY([SDT])
REFERENCES [dbo].[TaiKhoan] ([SDT])
GO
ALTER TABLE [dbo].[NguoiMua] CHECK CONSTRAINT [FK_NguoiMua_TaiKhoan]
GO
ALTER TABLE [dbo].[ThongBao]  WITH CHECK ADD  CONSTRAINT [FK_ThongBao_TaiKhoan] FOREIGN KEY([SDT])
REFERENCES [dbo].[TaiKhoan] ([SDT])
GO
ALTER TABLE [dbo].[ThongBao] CHECK CONSTRAINT [FK_ThongBao_TaiKhoan]
GO
ALTER TABLE [dbo].[ThongTinTaiKhoan]  WITH CHECK ADD  CONSTRAINT [FK_ThongTinTaiKhoan_TaiKhoan] FOREIGN KEY([SDT])
REFERENCES [dbo].[TaiKhoan] ([SDT])
GO
ALTER TABLE [dbo].[ThongTinTaiKhoan] CHECK CONSTRAINT [FK_ThongTinTaiKhoan_TaiKhoan]
GO
ALTER TABLE [dbo].[VatPham]  WITH CHECK ADD  CONSTRAINT [FK_VatPham_NguoiBan] FOREIGN KEY([MaNB])
REFERENCES [dbo].[NguoiBan] ([MaNB])
GO
ALTER TABLE [dbo].[VatPham] CHECK CONSTRAINT [FK_VatPham_NguoiBan]
GO
ALTER TABLE [dbo].[VatPham]  WITH CHECK ADD  CONSTRAINT [FK_VatPham_TheLoai] FOREIGN KEY([MaTL])
REFERENCES [dbo].[TheLoai] ([MaTL])
GO
ALTER TABLE [dbo].[VatPham] CHECK CONSTRAINT [FK_VatPham_TheLoai]
GO
/****** Object:  StoredProcedure [dbo].[BaoXauSanPham]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[BaoXauSanPham](
	@sdt nchar(50),@mavp int,@lydo nvarchar(500),@ghichu nvarchar(max)
)as begin
	insert into BaoXau(SDT,MaVP,LyDo,GhiChu) values (@sdt,@mavp,@lydo,@ghichu)
end
GO
/****** Object:  StoredProcedure [dbo].[DangKy]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DangKy](
	@HoTen nvarchar(500),@SDT nchar(50),@LoaiTK int,@email nchar(500),@matkhau nchar(100)
)as begin
	insert into TaiKhoan(SDT,MatKhau,LoaiTK) values (@SDT,@matkhau,@LoaiTK)
	insert into ThongTinTaiKhoan(SDT,HoTen,Email) values(@SDT,@HoTen,@email)
	declare @link nvarchar(max)
	set @link = '/DangTinBan/'+ cast(@SDT as nvarchar(max))
	insert into ThongBao(SDT,HinhAnh,NoiDungTB,Link) values(@SDT,'partner.png',N'Chào mừng bạn đến với Chợ Tốt, hãy tải ngay mặt hàng đầu tiên của bạn lên nào',@link)
	
end
GO
/****** Object:  StoredProcedure [dbo].[DatMuaVatPham]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DatMuaVatPham](
	@sdt nchar(50),@hoten nvarchar(500),@email nchar(500),
	@diachi nvarchar(max),@ghichu nvarchar(max),@mavp int
)as begin
	insert into NguoiMua(SDT,TenNM,Email,DiaChi) values (@sdt,@hoten,@email,@diachi)
	insert into DatMua(MaNM,MaVP,GhiChu) values(
		(select Max(MaNM) from NguoiMua),
		@mavp,@ghichu
	)
end
GO
/****** Object:  StoredProcedure [dbo].[SuaThongTinTaiKhoan]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SuaThongTinTaiKhoan](
@sdt nchar(50),@hoten nvarchar(500),@email nchar(500),@quequan nvarchar(500),@gioitinh nvarchar(200),@ngaysinh datetime
)as begin
	update ThongTinTaiKhoan set HoTen = @hoten,Email=@email,
		QueQuan = @quequan,GioiTinh=@gioitinh,NgaySinh=@ngaysinh where SDT = @sdt
	
end
GO
/****** Object:  StoredProcedure [dbo].[ThemAnhVaoVatPham]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ThemAnhVaoVatPham](
	@MaVP int,@strLinkAnh nvarchar(max)
)as begin
	while (CHARINDEX(',',@strLinkAnh) > 0) -- có nhiều link, cắt từng link theo dấu ','
	begin
		declare @link nvarchar(500)
		set @link = LEFT(@strLinkAnh,CHARINDEX(',',@strLinkAnh)-1)
		set @link = SUBSTRING(@link,CHARINDEX('uploads\',@strLinkAnh)+7,LEN(@link))
		insert into HinhAnh(Link) values (@link) -- thêm vào bảng hình ảnh
		-- kết nối hình ảnh với sản phẩm
		insert into HinhAnh_VatPham(MaHinhAnh,MaVatPham) values( 
			(select Max(MaHinhAnh) from HinhAnh),@MaVP
		)		
		set @strLinkAnh = SUBSTRING(@strLinkAnh,CHARINDEX(',',@strLinkAnh)+1,LEN(@strLinkAnh))
	end 
end
GO
/****** Object:  StoredProcedure [dbo].[ThemVatPham]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ThemVatPham](
	-- thông tin người bán
	@SDT nchar(50),@HoTen nvarchar(500),@MaTinhThanh int,@DiaChi nvarchar(500),
	-- vật phẩm
	@TenVP nvarchar(500), @MoTa nvarchar(max),@TinhTrang nvarchar(200),@GiaTien bigint,
	@MaTL int,@LinkHinhAnh nvarchar(max),
	-- hình ảnh
	@strLink nvarchar(max)
) 
as begin
	-- thêm vào bảng người bán
	insert into NguoiBan(MaTinhThanh,SDT,HoTen,DiaChi) values (@MaTinhThanh,@SDT,@HoTen,@DiaChi)
	-- thêm vào bảng vật phẩm	
	set @LinkHinhAnh = SUBSTRING(@LinkHinhAnh,CHARINDEX('uploads\',@LinkHinhAnh)+7,LEN(@LinkHinhAnh))
	insert into VatPham(MaNB,TenVP,MoTa,TinhTrang,GiaTien,MaTL,LinkHinhAnh) values
	(	
		(select MAX(MaNB) from NguoiBan),
		@TenVP,@MoTa,@TinhTrang,@GiaTien,@MaTL,@LinkHinhAnh
	)
	-- xử lí vật phẩm và hình ảnh
	declare @mavp int
	set @mavp = (select Max(MaVP) from VatPham)
	exec ThemAnhVaoVatPham @MaVP = @mavp ,@strLinkAnh = @strLink
end
GO
/****** Object:  StoredProcedure [dbo].[ThongBaoTaiKhoan]    Script Date: 6/19/2020 10:20:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ThongBaoTaiKhoan](
	@sdt nchar(50),@mavp int,@noidungtb nvarchar(max)
)as begin
	declare @linkAnh nvarchar(max)
	set @linkAnh = (select LinkHinhAnh from VatPham where MaVP = @mavp)
	declare @SDTnguoiban nchar(50)
	set @SDTnguoiban = (select TaiKhoan.SDT
	from TaiKhoan,NguoiBan,VatPham
	where TaiKhoan.SDT = NguoiBan.SDT and
		  NguoiBan.MaNB = VatPham.MaNB
		  and VatPham.MaVP = @mavp)		
	declare @src nvarchar(max)
	set @src = '/ChiTietVatPham/'+CONVERT(nvarchar,@mavp)
	insert into ThongBao(SDT,HinhAnh,NoiDungTB,Link) values (@SDTnguoiban,@linkAnh,@noidungtb,@src)
end
GO

create view VatPhamAdmin
as 
select MaVP, NguoiBan.HoTen,VatPham.TenVP, VatPham.MoTa,VatPham.TinhTrang, VatPham.GiaTien, TheLoai.TenTL,
VatPham.LinkHinhAnh,VatPham.NgayDang from VatPham,TheLoai,NguoiBan where VatPham.MaTL = TheLoai.MaTL and
VatPham.MaNB= NguoiBan.MaNB 

update VatPham set DaDuyet = 0 
go
update VatPham set BiKhoa = 0 
go
create table DSTaiKhoanBiKhoa
(
    SDT nchar(50) primary key,
	LyDo nvarchar (200),
	NgayKhoa datetime
)
alter table DSTaiKhoanBiKhoa add foreign key (SDT) references TaiKhoan (SDT)
go
create view VatPhamChoDuyet
as 
select MaVP, NguoiBan.HoTen,VatPham.TenVP, VatPham.MoTa,VatPham.TinhTrang, VatPham.GiaTien, TheLoai.TenTL,
VatPham.LinkHinhAnh,VatPham.DaDuyet,VatPham.NgayDang from VatPham,TheLoai,NguoiBan where VatPham.MaTL = TheLoai.MaTL and
VatPham.MaNB= NguoiBan.MaNB and VatPham.DaDuyet = 0
go
create view VatPhamBiKhoa
as 
select MaVP, NguoiBan.HoTen,VatPham.TenVP, VatPham.MoTa,VatPham.TinhTrang, VatPham.GiaTien, TheLoai.TenTL,
VatPham.LinkHinhAnh,VatPham.BiKhoa,VatPham.NgayDang from VatPham,TheLoai,NguoiBan where VatPham.MaTL = TheLoai.MaTL and
VatPham.MaNB= NguoiBan.MaNB and VatPham.BiKhoa = 1






