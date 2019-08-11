
% The values in this script is from the "contract_compare" by adapting the number of types. 
close all

%number of types vs utility of the SG
utility=[1.1357e3 1.1367e3 1.1384e3 1.1413e3 1.1462e3 1.1549e3   ]
compare=[614.3350 628.6101 645.7568 666.9318 694.1048 731.0137 ]
K=10:5:35;
figure
bar(K, [utility.', compare.'])
legend('Contract-based','Linear pricing')
set(legend,'FontSize',13,'FontName','Times New Roman')
xlabel('Number of Types','FontSize',13,'FontName','Times New Roman')
ylabel(' Utility of the Secondary Gateway','FontSize',13,'FontName','Times New Roman')



%number of types vs the average inceased amount of the ST's transmitted data
throughput=[1.4126e3 1.4363e3 1.4648e3 1.5e3 1.5455e3 1.6082e3   ]
throughput_compare=[962.8363 990.2207 1.0235e3 1.0653e3 1.1202e3 1.1971e3 ]
K=10:5:35;
figure
bar(K, [throughput.', throughput_compare.'])
legend('Contract-based','Linear pricing')
set(legend,'FontSize',13,'FontName','Times New Roman')
xlabel('Number of Types','FontSize',13,'FontName','Times New Roman')
ylabel({'Average Increased Amount'; 'of the ST''s Transmitted Data (bit)'},'FontSize',13,'FontName','Times New Roman')



