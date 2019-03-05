



filepath = 'proba.xlsx';
b = 6.908;

xlsdata = xlsread(filepath);

[T, width] = size(xlsdata);
width = 1;
t = 1:T;
derivt = 1:T-1;

results = zeros(7, width - 1);
for k = 1:width
    deltaQ = rmmissing(xlsdata(:, k));
    [parameters, Qtot] = wiebe(deltaQ);
    a1 = parameters(1);
    T1 = parameters(2);
    r1 = parameters(3);
    a2 = parameters(4);
    T2 = parameters(5);
    r2 = parameters(6);
    results(:, k) = [a1; T1; r1; a2; T2; r2; Qtot]; 
end

xlswrite('result.xls',results,'parametri');


for k = 1:width
    column = rmmissing(xlsdata(:, k));
    t = 1:length(column');
    
    rez = results(:, k)';
    a1 = rez(1);
    T1 = rez(2);
    r1 = rez(3);
    a2 = rez(4);
    T2 = rez(5);
    r2 = rez(6);
    Qtot = rez(7);

    A1 = r1*exp(-b*(t./T1).^a1);
    B1 = (t./T1).^(a1 - 1);
    C1 = a1* b/T1;
    
    A2 = r2*exp(-b* (t./T2).^a2);
    B2 = (t./T2).^(a2 - 1);
    C2 = a2* b/T2;
    dQ1 = Qtot.*A1.*B1.*C1;
    dQ2 = Qtot.*A2.*B2.*C2;
    formatedData = [t' column dQ1' dQ2' (dQ1 + dQ2)'];
    xlswrite('result.xls',formatedData ,k*10);
end


% figure
% for k = 1:width
%     parameters = result(:, k)';
%     a1 = parameters(1);
%     T1 = parameters(2);
%     r1 = parameters(3);
%     a2 = parameters(4);
%     T2 = parameters(5);
%     r2 = parameters(6);
%     Qtot = parameters(7);
%     
%     Q1 = Qtot*r1*(1 - exp(-b*(t./T1).^a1));
%     Q2 = Qtot*r2*(1 - exp(-b*(t./T2).^a2));
%     dQ1 =  Q1(2: end) - Q1(1: end-1);
%     dQ2 =  Q2(2: end) - Q2(1: end-1);
%     dQ = dQ1 + dQ2;
%     subplot(5, 2, k);
%     plot(derivt, dQ, t, xlsdata(:,k)');
%     
% end



