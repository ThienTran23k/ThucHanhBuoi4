--1)
--a)
--CREATE PROCEDURE IN_PROC_DEAN 
--    @MADA VARCHAR(2),
--    @TENDA NVARCHAR(50),
--    @DDIEM_DA VARCHAR(20),
--    @PHONG NVARCHAR(2)
--AS
--BEGIN
--    INSERT INTO DEAN(MADA, TENDA, DDIEM_DA, PHONG)
--    VALUES (@MADA, @TENDA, @DDIEM_DA, @PHONG)
--END
--check thủ tục
--EXEC sp_helptext 'IN_PROC_DEAN'
--EXEC IN_PROC_DEAN @MADA = '50', @TENDA = N'Trồng cây siêu tăng trưởng', @DDIEM_DA = N'Vũng Tàu', @PHONG = '5'
--b)
--CREATE PROCEDURE SE_PRO_DEAN 
--    @DDIEM_DA NVARCHAR(20)
--AS
--BEGIN
--    SELECT * FROM DEAN WHERE DDIEM_DA = @DDIEM_DA
--END

--EXEC SE_PRO_DEAN @DDIEM_DA = N'Vung Tàu'
--c)
--CREATE PROCEDURE UP_PROC_DEAN
--    @diadiem_old VARCHAR(20),
--    @diadiem_new VARCHAR(20)
--AS
--BEGIN
--    UPDATE DEAN
--    SET DDIEM_DA = @diadiem_new
--    WHERE DDIEM_DA = @diadiem_old;
--END;
--EXEC UP_PROC_DEAN 'Vung Tàu', 'Bà Rịa Vũng Tàu';
--d)
--CREATE PROCEDURE DEL_PROC_DEAN
--    @MaDean VARCHAR(2)
--AS
--BEGIN
--    DELETE FROM DEAN
--    WHERE MADA = @MaDean;
--END;
--EXEC DEL_PROC_DEAN '50';
--2)
--CREATE PROCEDURE TongGioLam
--    @MaNV NVARCHAR(50), 
--    @tonggio INT OUTPUT
--AS
--BEGIN
--    SELECT @tonggio = SUM(THOIGIAN) 
--    FROM PHANCONG 
--    WHERE MA_NVIEN = @MaNV
--END
--Check lại
--DECLARE @GIO INT
--EXEC TongGioLam @MaNV = '003', @tonggio = @GIO OUTPUT
--SELECT @GIO as TotalHours

--3)
--CREATE PROCEDURE INSERT_DEAN
--    @TENDA NVARCHAR(50), 
--    @MADA varchar(2), 
--    @DDIEM_DA NVARCHAR(20), 
--    @PHONG varchar(2)
--AS
--BEGIN
--    IF @MADA IS NULL OR EXISTS (SELECT 1 FROM DEAN WHERE MADA = @MADA)
--    BEGIN
--         print N'Bị trùng mã đề án hoặc mã đề án rỗng, chọn mã đề án khác!!!';
--		 return
--    END
--    ELSE
--	BEGIN
 
--        INSERT INTO DEAN (TENDA, MADA, DDIEM_DA, PHONG)
--        VALUES (@TENDA, @MADA, @DDIEM_DA, @PHONG)
--	END
    
--END
--EXEC INSERT_DEAN N'Sản phẩm C', 005, N'TP.HCM', 3
--4)

--CREATE PROCEDURE SALARY_REPORT
--AS
--BEGIN
--    DECLARE @MANV VARCHAR(9), @HONV NVARCHAR(15), @TENLOT NVARCHAR(30), @TENNV NVARCHAR(30), @NGSINH SMALLDATETIME, @PHAI NVARCHAR(3), @LUONG NUMERIC(18,0)
--    DECLARE @MADA VARCHAR(2), @TENDA NVARCHAR(50), @DDIEM_DA VARCHAR(20), @PHONG VARCHAR(2), @THOIGIAN INT
--    DECLARE @Total MONEY

--    DECLARE employee_cursor CURSOR FOR 
--    SELECT MANV, HONV, TENLOT, TENNV, NGSINH, PHAI, LUONG
--    FROM NHANVIEN

--    OPEN employee_cursor

--    FETCH NEXT FROM employee_cursor INTO @MANV, @HONV, @TENLOT, @TENNV, @NGSINH, @PHAI, @LUONG

--    WHILE @@FETCH_STATUS = 0
--    BEGIN
--        PRINT 'Nhân viên: ' + @MANV + ' – ' + @HONV + ' ' + @TENLOT + ' ' + @TENNV
--        PRINT CONVERT(VARCHAR, @NGSINH, 107) + ' - ' + @PHAI
--        PRINT 'Mã DA	Tên DA	Địa điểm	Thời gian	Lương	Tổng'

--        DECLARE project_cursor CURSOR FOR 
--        SELECT MADA, TENDA, DDIEM_DA, PHONG, THOIGIAN
--        FROM PHANCONG JOIN DEAN ON PHANCONG.SODA = DEAN.MADA
--        WHERE MA_NVIEN = @MANV

--        OPEN project_cursor

--        FETCH NEXT FROM project_cursor INTO @MADA, @TENDA, @DDIEM_DA, @PHONG, @THOIGIAN

--        WHILE @@FETCH_STATUS = 0
--        BEGIN
--            SET @Total = @THOIGIAN * @LUONG
--            PRINT @MADA + '	' + @TENDA + '	' + @DDIEM_DA + '	' + CONVERT(VARCHAR, @THOIGIAN) + '	' + CONVERT(VARCHAR, @LUONG) + '	' + CONVERT(VARCHAR, @Total)

--            FETCH NEXT FROM project_cursor INTO @MADA, @TENDA, @DDIEM_DA, @PHONG, @THOIGIAN
--        END

--        CLOSE project_cursor
--        DEALLOCATE project_cursor

--        FETCH NEXT FROM employee_cursor INTO @MANV, @HONV, @TENLOT, @TENNV, @NGSINH, @PHAI, @LUONG
--    END

--    CLOSE employee_cursor
--    DEALLOCATE employee_cursor
--END

--EXEC SALARY_REPORT

--5)
--CREATE PROCEDURE SUM_SALARY
--    @MANV NVARCHAR(50), 
--    @TotalSalary INT OUTPUT
--AS
--BEGIN
--    SELECT @TotalSalary = SUM(LUONG) 
--    FROM NHANVIEN 
--    WHERE MANV = @MANV
--END

--DECLARE @Salary INT
--EXEC SUM_SALARY '008', @Salary OUTPUT
--SELECT @Salary as TotalSalary
--6)

--CREATE PROCEDURE INSERT_PHANCONG
--    @MA_NVIEN NVARCHAR(9), 
--    @SODA INT, 
--    @STT INT, 
--    @THOIGIAN INT
--AS
--BEGIN
--    IF @THOIGIAN <= 0
--    BEGIN
--        PRINT N'THOIGIAN phải lớn hơn 0';
--        RETURN;
--    END

--    IF NOT EXISTS (SELECT 1 FROM DEAN WHERE MADA = @SODA)
--    BEGIN
--        PRINT N'SoDA phải tồn tại trong bảng DeAn';
--        RETURN;
--    END

--    INSERT INTO PHANCONG (MA_NVIEN, SODA, STT, THOIGIAN)
--    VALUES (@MA_NVIEN, @SODA, @STT, @THOIGIAN)
--END
-- Trường hợp đúng: THOIGIAN > 0 và SoDA tồn tại trong bảng DeAn
--EXEC INSERT_PHANCONG '009', 1, 1, 32

-- Trường hợp sai: THOIGIAN <= 0
--EXEC INSERT_PHANCONG '009', 1, 1, 0

---- Trường hợp sai: SoDA không tồn tại trong bảng DeAn
--EXEC INSERT_PHANCONG '009', 999, 1, 32


--7)
----Thêm cột HIRE_DAY
--ALTER TABLE NHANVIEN
--ADD HIRE_DATE DATE;

--CREATE PROCEDURE UPDATE_HIRE_DATE
--    @NGSINH DATE
--AS
--BEGIN
--    DECLARE @currentAge INT;
--    SET @currentAge = DATEDIFF(YEAR, @NGSINH, GETDATE());
--    IF @currentAge >= 65
--    BEGIN
--        UPDATE NHANVIEN
--        SET HIRE_DATE = DATEADD(DAY, 100, GETDATE())
--        WHERE NGSINH = @NGSINH;
--    END
--END

--Test thử
--EXEC UPDATE_HIRE_DATE '1954-03-11';

----9&10
--1)
--CREATE TRIGGER trg_Update_TENNV
--ON NHANVIEN
--FOR UPDATE
--AS
--BEGIN
--    IF UPDATE(TENNV)
--    BEGIN
--        THROW 51000, N'Không được cập nhật', 1;
--        ROLLBACK TRANSACTION;
--    END
--END

--Check lại
-- Thử cập nhật trường TENNV
--UPDATE NHANVIEN
--SET TENNV = N'ABC'
--WHERE MANV = '001';


--2)
----thêm cột ToTal_Time vào bảng NHANVIEN
--ALTER TABLE NHANVIEN
--ADD ToTal_Time INT DEFAULT 0;

--CREATE TRIGGER trg_PhanCong
--ON PhanCong
--AFTER INSERT, UPDATE, DELETE
--AS
--BEGIN
--    UPDATE NHANVIEN
--    SET ToTal_Time = (SELECT SUM(THOIGIAN) FROM PhanCong WHERE MA_NVIEN = NHANVIEN.MANV)
--END

--Để thử :
-- Thêm một bản ghi vào bảng PhanCong
--INSERT INTO PhanCong (MA_NVIEN, SODA, STT, THOIGIAN)
--VALUES ('010', 1, 1, 32)

---- Cập nhật một bản ghi trong bảng PhanCong
--UPDATE PhanCong
--SET THOIGIAN = 40
--WHERE MA_NVIEN = '010' AND SODA = 1

---- Xóa một bản ghi từ bảng PhanCong
--DELETE FROM PhanCong
--WHERE MA_NVIEN = '010' AND SODA = 1

--Check lại :
--SELECT ToTal_Time FROM NHANVIEN WHERE MANV = '009'

--3)

--CREATE TRIGGER trg_Nhanvien
--ON Nhanvien
--AFTER INSERT, UPDATE
--AS
--BEGIN
--    IF EXISTS (SELECT 1 FROM inserted i WHERE i.NGSINH >= DATEADD(yy, -40, i.HIRE_DATE))
--    BEGIN
--        RAISERROR ('ngaysinh phải nhỏ hơn Hire_date - 40 năm', 16, 1);
--        ROLLBACK TRANSACTION;
--    END
--END

----Test :
--UPDATE NHANVIEN
--set NGSINH ='2003-06-06'
--where MANV ='007';

--4)
--CREATE TRIGGER trg_THANNHAN
--ON THANNHAN
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @NhanvienID INT;
--    SELECT @NhanvienID = MA_NVIEN FROM inserted;

--    IF (SELECT COUNT(*) FROM THANNHAN WHERE MA_NVIEN = @NhanvienID) > 5
--    BEGIN
--        RAISERROR ('Mỗi nhân viên không được có quá 5 người thân', 16, 1);
--        ROLLBACK TRANSACTION;
--    END
--END;

----Check thử :
--INSERT INTO THANNHAN (MA_NVIEN,TENTN)
--VALUES ('005', 'A'),
--       ('005', 'B'),
--       ('005', 'C'),
--       ('005', 'D'),
--       ('005', 'E');






