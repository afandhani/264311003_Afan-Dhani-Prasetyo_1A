SELECT p.nama,
       COUNT(s.id_sesi) AS jumlah_sesi,
       SUM(TIMESTAMPDIFF(MINUTE, s.waktu_login, s.waktu_logout)) AS total_menit
FROM sesi_login s
JOIN pengguna p ON s.id_pengguna = p.id_pengguna
WHERE s.status_sesi = 'Selesai'
GROUP BY p.id_pengguna, p.nama;
