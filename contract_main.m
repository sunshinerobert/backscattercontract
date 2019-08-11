clear
close all
global alpha R_b trans_eff B  AAA BBB_vector P_0
alpha=0.8;  %nomalized busy period
%the backscatter rate, the bandwidth, and the cost are reduced
%to 1e-6 of the original value in the most of the simulations in order to
%improve the calculation accuracy. We will increase the  result by 1e6
%times to obtain the correct final result.
R_b=0.03; % backscatter rate
trans_eff=0.6; % active transmission effeicicy
B=0.1; % bandwidth
cost_unit=0.001; %cost per unit time


K=20; % number of types
probablity=1/K; % probablity of each type
delta_P_h=0.1e-3*1e-3; % difference of the harvested power between two adjacent types
start_P_h=5e-3*1e-3;  % harvested power of type 1 
P_h_vector=start_P_h:-delta_P_h:start_P_h-delta_P_h*(K-1);
P_0=10^(-60/10); % ratio between the noise and the channel gain



AAA=trans_eff*B*(1-alpha);
BBB_vector=P_h_vector./(1-alpha)./P_0;




upbound=zeros(1,K);

x0=0.1;
for type=1:K
[solution,objective,exitflag]=fmincon(@(x)(-f_throughput(type,x)),x0,[],[],[],[],0,alpha);
upbound(type)=solution;
end




J_k_final=[];
xxx_final=[];

%deriving the assigned backscatter type for each type
for type=1:K
    syms a
    if type<K
    first_order=(R_b-AAA.*BBB_vector(type)/log(2)./(1+BBB_vector(type)*(alpha-a)))*probablity.*(K-type+1)-...
                (R_b-AAA.*BBB_vector(type+1)/log(2)./(1+BBB_vector(type+1)*(alpha-a)))*probablity.*(K-type)-cost_unit*probablity;
    else
     first_order=(R_b-AAA.*BBB_vector(type)/log(2)./(1+BBB_vector(type)*(alpha-a)))*probablity.*(K-type+1)-...
               cost_unit*probablity;    
    end
     solution= solve(@(a)first_order,a);
     xxx=double(solution);
     xxx(find(xxx>upbound(type)))=[];
     xxx(find(xxx<0))=[];
     J_k=[];
     for length_xxx=1:length(xxx)
         if type<K
          J_k_temp=(f_throughput(type,xxx(length_xxx))-f_throughput(type,0))*probablity.*(K-type+1)-....
         (f_throughput(type+1,xxx(length_xxx))-f_throughput(type+1,0))*probablity.*(K-type)-cost_unit*probablity*xxx(length_xxx);   
         else
          J_k_temp=(f_throughput(type,xxx(length_xxx))-f_throughput(type,0))*probablity.*(K-type+1)-....
                cost_unit*probablity*xxx(length_xxx);    
         end
         J_k=[J_k,J_k_temp];
     end
     J_k_0=0;
     if type<K
     J_k_upbound=(f_throughput(type,upbound(type))-f_throughput(type,0))*probablity.*(K-type+1)-....
         (f_throughput(type+1,upbound(type))-f_throughput(type+1,0))*probablity.*(K-type)-cost_unit*probablity*upbound(type);
     else
      J_k_upbound=(f_throughput(type,upbound(type))-f_throughput(type,0))*probablity.*(K-type+1)-....
         cost_unit*probablity*upbound(type);
     end
         
     J_k=[J_k,J_k_0,J_k_upbound];
     xxx=[xxx,0,upbound(type)];
     J_k_final_temp=J_k(find(J_k==max(J_k)));
     xxx_final_temp=xxx(find(J_k==max(J_k)));
     J_k_final=[J_k_final,J_k_final_temp(1)]
     xxx_final=[xxx_final,xxx_final_temp(1)]
end

%deriving the price for the ST 
payment_vector=zeros(1,K);
for type=1:K
    if type==1
        payment_vector(type)=f_throughput(type,xxx_final(type))-f_throughput(type,0);
    else
        payment_vector(type)= payment_vector(type-1)+f_throughput(type,xxx_final(type))-f_throughput(type,xxx_final(type-1));
    end
end
xxx_final
payment_vector


%calculating the utlity of the ST choosing the contract item designed for different types.
utility_type=zeros(K,K);

for type=1:K
    for type_quality=1:K
        utility_type(type,type_quality)=1e6*(f_throughput(type,xxx_final(type_quality))-f_throughput(type,0)-payment_vector(type_quality))
    end
end
utility=utility_type.';




figure
type=1:K;
plot(type,utility(:,10),'bo-',type,utility(:,12),'r*-',type,utility(:,14),'md-','LineWidth',1.5,'MarkerSize',6)
axis([2 18 60 120])
grid on;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1);
legend('Type {{\theta}}_{10}','Type {{\theta}}_{12}', 'Type {{\theta}}_{14}');
set(legend,'FontSize',13,'FontName','Times New Roman')
xlabel('Contract Item','FontSize',13,'FontName','Times New Roman')
ylabel('Utility of the Secondary Transmitter','FontSize',13,'FontName','Times New Roman')


