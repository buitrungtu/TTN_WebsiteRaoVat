USE [master]
GO
/****** Object:  Database [Website_RaoVat]    Script Date: 6/23/20 6:00:54 PM ******/
CREATE DATABASE [Website_RaoVat]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Website_RaoVat', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\Website_RaoVat.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Website_RaoVat_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\Website_RaoVat_log.ldf' , SIZE = 816KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Website_RaoVat] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Website_RaoVat].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Website_RaoVat] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Website_RaoVat] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Website_RaoVat] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Website_RaoVat] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Website_RaoVat] SET ARITHABORT OFF 
GO
ALTER DATABASE [Website_RaoVat] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Website_RaoVat] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Website_RaoVat] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Website_RaoVat] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Website_RaoVat] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Website_RaoVat] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Website_RaoVat] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Website_RaoVat] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Website_RaoVat] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Website_RaoVat] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Website_RaoVat] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Website_RaoVat] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Website_RaoVat] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Website_RaoVat] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Website_RaoVat] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Website_RaoVat] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Website_RaoVat] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Website_RaoVat] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Website_RaoVat] SET  MULTI_USER 
GO
ALTER DATABASE [Website_RaoVat] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Website_RaoVat] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Website_RaoVat] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Website_RaoVat] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Website_RaoVat] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Website_RaoVat]
GO
/****** Object:  UserDefinedFunction [dbo].[DanhSachVatPham]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[DanhSachVatPham](@MaDM int)
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
				and DaDuyet = 1 and BiKhoa = 0
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
				and DaDuyet = 1 and BiKhoa = 0
	end
	return
end

GO
/****** Object:  UserDefinedFunction [dbo].[LayHinhAnh]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[LayThongTinTaiKhoan]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[ThongTinVatPham]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[TimKiem]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[TimKiem](@str nvarchar(100), @matl int)
returns @BangChiTiet table (MaVP int,TenVP nvarchar(500),HoTen nvarchar(500),SDT varchar(50), TenTinhThanh nvarchar(500),
	MoTa nvarchar(max), TinhTrang nvarchar(500),GiaTien bigint,
	TenTL nvarchar(500),NgayDang int,LinkHinhAnh varchar(Max),ChatLuong int,
	DiaChi nvarchar(500))
as begin
   if ( @matl= 0 )
   begin 
      insert into @BangChiTiet
			select MaVP,TenVP,HoTen,SDT,TenTinhThanh,MoTa,TinhTrang,GiaTien,TenTL,
			DATEDIFF(HOUR,NgayDang,GETDATE()),LinkHinhAnh,ChatLuong,NguoiBan.DiaChi
			from VatPham,NguoiBan,Tinh_Thanh,TheLoai
			where VatPham.MaNB = NguoiBan.MaNB
				and NguoiBan.MaTinhThanh = Tinh_Thanh.MaTinhThanh
				and VatPham.MaTL = TheLoai.MaTL
				and DaDuyet = 1 and BiKhoa = 0
				and TenVP like '%'+@str+'%'
   end 
   else 
   begin
      insert into @BangChiTiet
			select MaVP,TenVP,HoTen,SDT,TenTinhThanh,MoTa,TinhTrang,GiaTien,TenTL,
			DATEDIFF(HOUR,NgayDang,GETDATE()),LinkHinhAnh,ChatLuong,NguoiBan.DiaChi
			from VatPham,NguoiBan,Tinh_Thanh,TheLoai
			where VatPham.MaNB = NguoiBan.MaNB
				and NguoiBan.MaTinhThanh = Tinh_Thanh.MaTinhThanh
				and VatPham.MaTL = TheLoai.MaTL and TheLoai.MaTL = @matl
				and DaDuyet = 1 and BiKhoa = 0
				and TenVP like '%'+@str+'%'
   end
   return 
end
GO
/****** Object:  UserDefinedFunction [dbo].[VatPhamDaDangCua]    Script Date: 6/23/20 6:00:54 PM ******/
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
			DATEDIFF(HOUR,NgayDang,GETDATE()),LinkHinhAnh,DaDuyet,NgungBan
			from VatPham join NguoiBan on VatPham.MaNB = NguoiBan.MaNB
			where DaDuyet = 1 and NgungBan = 0 and SDT = @sdt							
	return
end

GO
/****** Object:  Table [dbo].[BaoXau]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  Table [dbo].[DatMua]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  Table [dbo].[DSTaiKhoanBiKhoa]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DSTaiKhoanBiKhoa](
	[SDT] [nchar](50) NOT NULL,
	[LyDo] [nvarchar](200) NULL,
	[NgayKhoa] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[SDT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HinhAnh]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  Table [dbo].[HinhAnh_VatPham]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HinhAnh_VatPham](
	[MaVatPham] [int] NULL,
	[MaHinhAnh] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NguoiBan]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  Table [dbo].[NguoiMua]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  Table [dbo].[NhanVien]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNV] [int] NULL,
	[ChucVu] [nvarchar](200) NULL,
	[TenNV] [nvarchar](500) NULL,
	[SDT] [nchar](50) NULL,
	[DiaChi] [nvarchar](max) NULL,
	[username] [nchar](50) NULL,
	[password] [nchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaiKhoan]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaiKhoan](
	[SDT] [nchar](50) NOT NULL,
	[MatKhau] [nchar](100) NULL,
	[LoaiTK] [int] NULL,
	[NgayTao] [datetime] NULL CONSTRAINT [DF_TaiKhoan_NgayTao]  DEFAULT (getdate()),
 CONSTRAINT [PK_TaiKhoan] PRIMARY KEY CLUSTERED 
(
	[SDT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TheLoai]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  Table [dbo].[ThongBao]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThongBao](
	[MaTB] [int] IDENTITY(1,1) NOT NULL,
	[HinhAnh] [nvarchar](max) NULL,
	[NoiDungTB] [nvarchar](max) NULL,
	[SDT] [nchar](50) NULL,
	[DaDoc] [int] NULL CONSTRAINT [DF_ThongBao_DaDoc]  DEFAULT ((0)),
	[Link] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ThongTinTaiKhoan]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  Table [dbo].[Tinh_Thanh]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  Table [dbo].[VatPham]    Script Date: 6/23/20 6:00:54 PM ******/
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
	[NgayDang] [datetime] NULL CONSTRAINT [DF_VatPham_NgayDang]  DEFAULT (getdate()),
	[ChatLuong] [int] NULL CONSTRAINT [DF_VatPham_ChatLuong]  DEFAULT ((3)),
	[DaDuyet] [int] NULL CONSTRAINT [DF_VatPham_KiemDuyet]  DEFAULT ((0)),
	[BiKhoa] [int] NULL CONSTRAINT [DF_VatPham_NgungBan]  DEFAULT ((0)),
	[NgungBan] [int] NULL CONSTRAINT [DF_VatPham_NgungBan_1]  DEFAULT ((0)),
 CONSTRAINT [PK_VatPham] PRIMARY KEY CLUSTERED 
(
	[MaVP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[YeuThich]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[YeuThich](
	[SDT] [nchar](50) NOT NULL,
	[MaVP] [int] NOT NULL,
	[ThoiGian] [datetime] NULL CONSTRAINT [DF_YeuThich_ThoiGian]  DEFAULT (getdate()),
 CONSTRAINT [PK_YeuThich] PRIMARY KEY CLUSTERED 
(
	[SDT] ASC,
	[MaVP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[MatHangMoiNhat]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[MatHangMoiNhat]
as 
	select top 12 MaVP,TenVP,GiaTien,LinkHinhAnh,DATEDIFF(HOUR,NgayDang,GETDATE())as[Ngày] 
	from VatPham where BiKhoa = 0 and DaDuyet = 1 and NgungBan = 0
	order by NgayDang desc

GO
/****** Object:  View [dbo].[NhanPhanHoi]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[NhanPhanHoi] 
as
select ThongTinTaiKhoan.HoTen, VatPham.MaVP, VatPham.TenVP, BaoXau.LyDo, BaoXau.GhiChu   from VatPham, BaoXau,TaiKhoan, ThongTinTaiKhoan 
where VatPham.MaVP= BaoXau.MaVP and BaoXau.SDT= TaiKhoan.SDT
and TaiKhoan.SDT= ThongTinTaiKhoan.SDT
GO
/****** Object:  View [dbo].[VatPhamAdmin]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VatPhamAdmin]
as 
select MaVP, NguoiBan.HoTen,VatPham.TenVP, VatPham.MoTa,VatPham.TinhTrang, VatPham.GiaTien, TheLoai.TenTL,
VatPham.LinkHinhAnh,VatPham.NgayDang from VatPham,TheLoai,NguoiBan where VatPham.MaTL = TheLoai.MaTL and
VatPham.MaNB= NguoiBan.MaNB 
GO
/****** Object:  View [dbo].[VatPhamBiKhoa]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VatPhamBiKhoa]
as 
select MaVP, NguoiBan.HoTen,VatPham.TenVP, VatPham.MoTa,VatPham.TinhTrang, VatPham.GiaTien, TheLoai.TenTL,
VatPham.LinkHinhAnh,VatPham.BiKhoa,VatPham.NgayDang from VatPham,TheLoai,NguoiBan where VatPham.MaTL = TheLoai.MaTL and
VatPham.MaNB= NguoiBan.MaNB and VatPham.BiKhoa = 1
GO
/****** Object:  View [dbo].[VatPhamChoDuyet]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VatPhamChoDuyet]
as 
select MaVP, NguoiBan.HoTen,VatPham.TenVP, VatPham.MoTa,VatPham.TinhTrang, VatPham.GiaTien, TheLoai.TenTL,
VatPham.LinkHinhAnh,VatPham.DaDuyet,VatPham.NgayDang from VatPham,TheLoai,NguoiBan where VatPham.MaTL = TheLoai.MaTL and
VatPham.MaNB= NguoiBan.MaNB and VatPham.DaDuyet = 0
GO
/****** Object:  View [dbo].[VatPhamHotNhat]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VatPhamHotNhat]
as
	select top 3 MaVP,TenVP,GiaTien,LinkHinhAnh
	from VatPham where BiKhoa =0 and DaDuyet = 1 and NgungBan = 0
	order by (select COUNT(*) from YeuThich where MaVP = VatPham.MaVP) desc

GO
ALTER TABLE [dbo].[DatMua] ADD  CONSTRAINT [DF_DatMua_ThoiGian]  DEFAULT (getdate()) FOR [ThoiGian]
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
ALTER TABLE [dbo].[DSTaiKhoanBiKhoa]  WITH CHECK ADD FOREIGN KEY([SDT])
REFERENCES [dbo].[TaiKhoan] ([SDT])
GO
ALTER TABLE [dbo].[DSTaiKhoanBiKhoa]  WITH CHECK ADD FOREIGN KEY([SDT])
REFERENCES [dbo].[TaiKhoan] ([SDT])
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
ALTER TABLE [dbo].[YeuThich]  WITH CHECK ADD  CONSTRAINT [FK_YeuThich_TaiKhoan] FOREIGN KEY([SDT])
REFERENCES [dbo].[TaiKhoan] ([SDT])
GO
ALTER TABLE [dbo].[YeuThich] CHECK CONSTRAINT [FK_YeuThich_TaiKhoan]
GO
ALTER TABLE [dbo].[YeuThich]  WITH CHECK ADD  CONSTRAINT [FK_YeuThich_VatPham] FOREIGN KEY([MaVP])
REFERENCES [dbo].[VatPham] ([MaVP])
GO
ALTER TABLE [dbo].[YeuThich] CHECK CONSTRAINT [FK_YeuThich_VatPham]
GO
/****** Object:  StoredProcedure [dbo].[BaoXauSanPham]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DangKy]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  StoredProcedure [dbo].[DatMuaVatPham]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SuaThongTinTaiKhoan]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ThemAnhVaoVatPham]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ThemVatPham]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  StoredProcedure [dbo].[ThongBaoTaiKhoan]    Script Date: 6/23/20 6:00:54 PM ******/
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
/****** Object:  StoredProcedure [dbo].[XoaVatPham]    Script Date: 6/23/20 6:00:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[XoaVatPham](@mavp int)
as begin
	delete from HinhAnh_VatPham where MaVatPham = @mavp
	delete from BaoXau where MaVP = @mavp
	delete from DatMua where MaVP = @mavp
	delete from VatPham where MaVP = @mavp
end

GO
USE [master]
GO
ALTER DATABASE [Website_RaoVat] SET  READ_WRITE 
GO
