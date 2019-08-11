function [ f ] = f_throughput(type,x)
global alpha R_b trans_eff B     AAA BBB_vector P_0




throughput=R_b*x+AAA*log2(1+BBB_vector(type)*((alpha-x)));


f=throughput;
end

