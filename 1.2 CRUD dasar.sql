-- Create :

INSERT INTO pengguna (nama, peran, jurusan) VALUES
('Alucard Hellsing', 'Siswa', 'DKV'),
('Madison Beer',   'Siswa', 'IT'),
('Yoo Ji-min',   'Guru',  'IT');

INSERT INTO komputer (nama_komputer, lokasi_lab, status) VALUES
('PC-LAB1-01', 'Lab 1', 'Tersedia'),
('PC-LAB1-02', 'Lab 1', 'Tersedia'),
('PC-LAB2-01', 'Lab 2', 'Tersedia');

INSERT INTO sesi_login (id_pengguna, id_komputer, waktu_login, waktu_logout, status_sesi) VALUES
(1, 1, '2026-10-20 08:00:00', '2026-10-20 09:30:00', 'Selesai'),
(2, 2, '2026-10-20 08:05:00', '2026-10-20 10:00:00', 'Selesai'),
(1, 3, '2026-10-21 13:00:00', NULL, 'Aktif');

-- Read :

SELECT * FROM pengguna;

-- Update :

UPDATE sesi_login
SET status_sesi = 'Selesai', waktu_logout = '2026-10-21 14:30:00'
WHERE id_sesi = 3;

-- Delete :

DELETE FROM sesi_login
WHERE id_sesi = 2;
