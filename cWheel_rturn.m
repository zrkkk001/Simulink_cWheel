% 拟合公式% y=A*log(1+B*x^C)+D*x+E
clear
clc;

P=[1	5.9688	10.406	18	23.969	31	39.656	48.531	57.094	66.344	75.969	86	93.938	104.91	113.78	125.56	132.53
];sctravel=[1.6094	2.043	2.5039	3.0586	3.457	3.957	4.543	5.0781	5.5547	6.0469	6.5234	7.043	7.4883	8.0195	8.4922	9.1328	9.4219
];
 V=sctravel.*(387.6/1000); %需液量
 
% V=g_fta15_PedalTravel2dcl_Cft_BKs_CMP

%选择前后轴 'FA / RA / FA_RA'
xlab='FA';




%% 后续内容为计算过程 勿动！
%PV_Curve x轴参数
xlab_FA=[1.0  2.0  3.0  5.0  8.0  12.0  20.0  30.0  45.0 55.0 70.0 85.0 100.0  130.0];
xlab_RA=[1.0  2.0  3.0  5.0  8.0  12.0  20.0  30.0  45.0 55.0 70.0 85.0 100.0  130.0];
xlab_FA_RA=[1.0  2.0  3.0  5.0  8.0  12.0  20.0  30.0  45.0 55.0 70.0 85.0 100.0  130.0];



[xData, yData] = prepareCurveData( P, V );
a=createFit1(xData, yData);% 曲线拟合算得参数

syms  x  
y=a.p1*x^5 + a.p2*x^4 + a.p3*x^3 + a.p4*x^2 + a.p5*x +a.p6

dz=diff(y,x);
yins=symfun(y,x);%算得PV曲线函数
fins=symfun(dz,x);%算得导数函数

if xlab=='FA'
    axle=xlab_FA;
elseif xlab=='RA'
axle=xlab_RA;

% else xlab=='FA_RA' %数组个数不统一 注释
% axle=xlab_FA_RA;
end
dy=eval (yins(axle));%根据PV曲线函数 取得不同压力下对应的 需液量
da=eval (fins(axle));%根据导数函数    取得不同压力下对应的 斜率值 

ka=eval (fins(100));%算出 100bar下对应的   斜率值    即a值         y=ax+b
kv=eval(yins(100)); %算出100bar下对应的   需液量     即y值         y=ax+b 
Elas100=ka*100 ;    %算出100bar下对应的   Elas100值  即y-b的值(ax) y=ax+b 
 
c_pv=100/Elas100  %即求得100bar下对应的的刚度值 1/a  单位（bar/ml）
PV_Curve= ka./ da %将100bar做为基准 算出value数组    





%% 用于展示曲线 已注释
hold on
subplot(2,3,1) %将图形窗口分为n行m列个格子(在第k个格子上绘图)
plot(sctravel,P,'*-')
title('压力随位移的关系')%将图形窗口分为n行m列个格子(在第k个格子上绘图)
xlabel('x(mm) ')
ylabel('P(bar)')

subplot(2,3,2) %将图形窗口分为n行m列个格子(在第k个格子上绘图)
plot(V,P,'*-r',V,p2,'g')
title('压力随减少体积的关系及其拟合曲线')%将图形窗口分为n行m列个格子(在第k个格子上绘图)
xlabel('V(ml) ')
ylabel('P(bar)')

subplot(2,3,3) %将图形窗口分为n行m列个格子(在第k个格子上绘图)
plot(V,cWheel,'*-')
title('对曲线求导，得到刚度与减少体积的关系')%将图形窗口分为n行m列个格子(在第k个格子上绘图)
xlabel('V(ml) ')
ylabel('cWheel(bar/ml)')

subplot(2,3,4:6)
plot(P,cWheel,'*-')
title({'因为刚度值并不是常数C，可以建立刚度与减少体积的映射，最终得到刚度与压力的查表曲线，','所以刚度是和压力一一对应的，知道某个时刻的压力就能得到刚度值'})%将图形窗口分为n行m列个格子(在第k个格子上绘图)
xlabel('P（bar） ')
ylabel('cWheel(bar/ml)')


%% 拟合函数调用函数 勿动！
function [fitresult, gof] = createFit1(P, V)
%CREATEFIT(P,V)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : P
%      Y Output: V
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 14-Nov-2024 09:43:15 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( P, V );

% Set up fittype and options.
ft = fittype( 'poly5' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'V vs. P', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'P', 'Interpreter', 'none' );
ylabel( 'V', 'Interpreter', 'none' );
grid on






end