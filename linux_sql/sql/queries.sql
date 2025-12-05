INSERT INTO host_info (id, hostname, cpu_number, cpu_architecture,
cpu_model, cpu_mhz, l2_cache, "timestamp", total_mem)
VALUES(1, 'jrvs-remote-desktop.northamerica-northeast2-a.c.peerless-sensor-479317-v9.internal', 1,
'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, '2019-05-29 17:49:53.000', 601324);

--INSERT INTO host_info (id, hostname, cpu_number, cpu_architecture,
--cpu_model, cpu_mhz, l2_cache, "timestamp", total_mem)
--VALUES(2, 'noe1', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300,
--256, '2019-05-29 17:49:53.000', 601324);

--INSERT INTO host_info (id, hostname, cpu_number, cpu_architecture,
--cpu_model, cpu_mhz, l2_cache, "timestamp", total_mem)
--VALUES(3, 'noe2', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300,
--256, '2019-05-29 17:49:53.000', 601324);

-- Verify inserted data
SELECT * FROM host_info;