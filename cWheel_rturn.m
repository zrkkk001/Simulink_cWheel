% ��Ϲ�ʽ% y=A*log(1+B*x^C)+D*x+E
clear
clc;

P=[1	5.9688	10.406	18	23.969	31	39.656	48.531	57.094	66.344	75.969	86	93.938	104.91	113.78	125.56	132.53
];sctravel=[1.6094	2.043	2.5039	3.0586	3.457	3.957	4.543	5.0781	5.5547	6.0469	6.5234	7.043	7.4883	8.0195	8.4922	9.1328	9.4219
];
 V=sctravel.*(387.6/1000); %��Һ��
 
% V=g_fta15_PedalTravel2dcl_Cft_BKs_CMP

%ѡ��ǰ���� 'FA / RA / FA_RA'
xlab='FA';




%% ��������Ϊ������� �𶯣�
%PV_Curve x�����
xlab_FA=[1.0  2.0  3.0  5.0  8.0  12.0  20.0  30.0  45.0 55.0 70.0 85.0 100.0  130.0];
xlab_RA=[1.0  2.0  3.0  5.0  8.0  12.0  20.0  30.0  45.0 55.0 70.0 85.0 100.0  130.0];
xlab_FA_RA=[1.0  2.0  3.0  5.0  8.0  12.0  20.0  30.0  45.0 55.0 70.0 85.0 100.0  130.0];



[xData, yData] = prepareCurveData( P, V );
a=createFit1(xData, yData);% ���������ò���

syms  x  
y=a.p1*x^5 + a.p2*x^4 + a.p3*x^3 + a.p4*x^2 + a.p5*x +a.p6

dz=diff(y,x);
yins=symfun(y,x);%���PV���ߺ���
fins=symfun(dz,x);%��õ�������

if xlab=='FA'
    axle=xlab_FA;
elseif xlab=='RA'
axle=xlab_RA;

% else xlab=='FA_RA' %���������ͳһ ע��
% axle=xlab_FA_RA;
end
dy=eval (yins(axle));%����PV���ߺ��� ȡ�ò�ͬѹ���¶�Ӧ�� ��Һ��
da=eval (fins(axle));%���ݵ�������    ȡ�ò�ͬѹ���¶�Ӧ�� б��ֵ 

ka=eval (fins(100));%��� 100bar�¶�Ӧ��   б��ֵ    ��aֵ         y=ax+b
kv=eval(yins(100)); %���100bar�¶�Ӧ��   ��Һ��     ��yֵ         y=ax+b 
Elas100=ka*100 ;    %���100bar�¶�Ӧ��   Elas100ֵ  ��y-b��ֵ(ax) y=ax+b 
 
c_pv=100/Elas100  %�����100bar�¶�Ӧ�ĵĸն�ֵ 1/a  ��λ��bar/ml��
PV_Curve= ka./ da %��100bar��Ϊ��׼ ���value����    





%% ����չʾ���� ��ע��
hold on
subplot(2,3,1) %��ͼ�δ��ڷ�Ϊn��m�и�����(�ڵ�k�������ϻ�ͼ)
plot(sctravel,P,'*-')
title('ѹ����λ�ƵĹ�ϵ')%��ͼ�δ��ڷ�Ϊn��m�и�����(�ڵ�k�������ϻ�ͼ)
xlabel('x(mm) ')
ylabel('P(bar)')

subplot(2,3,2) %��ͼ�δ��ڷ�Ϊn��m�и�����(�ڵ�k�������ϻ�ͼ)
plot(V,P,'*-r',V,p2,'g')
title('ѹ�����������Ĺ�ϵ�����������')%��ͼ�δ��ڷ�Ϊn��m�и�����(�ڵ�k�������ϻ�ͼ)
xlabel('V(ml) ')
ylabel('P(bar)')

subplot(2,3,3) %��ͼ�δ��ڷ�Ϊn��m�и�����(�ڵ�k�������ϻ�ͼ)
plot(V,cWheel,'*-')
title('�������󵼣��õ��ն����������Ĺ�ϵ')%��ͼ�δ��ڷ�Ϊn��m�и�����(�ڵ�k�������ϻ�ͼ)
xlabel('V(ml) ')
ylabel('cWheel(bar/ml)')

subplot(2,3,4:6)
plot(P,cWheel,'*-')
title({'��Ϊ�ն�ֵ�����ǳ���C�����Խ����ն�����������ӳ�䣬���յõ��ն���ѹ���Ĳ�����ߣ�','���Ըն��Ǻ�ѹ��һһ��Ӧ�ģ�֪��ĳ��ʱ�̵�ѹ�����ܵõ��ն�ֵ'})%��ͼ�δ��ڷ�Ϊn��m�и�����(�ڵ�k�������ϻ�ͼ)
xlabel('P��bar�� ')
ylabel('cWheel(bar/ml)')


%% ��Ϻ������ú��� �𶯣�
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
%  ������� FIT, CFIT, SFIT.

%  �� MATLAB �� 14-Nov-2024 09:43:15 �Զ�����


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