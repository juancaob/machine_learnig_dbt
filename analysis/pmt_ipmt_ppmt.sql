{% set pay_type=  0 %}
{% set fv=   100000 %}
{% set pv=  -400000 %}
{% set rate= 0.06/12 %}
{% set nper= 12*20  %}
{% set period= 13 %}


{{ pmt(pay_type, pv, fv, rate, nper) }}

{{ ipmt(rate, period, nper, pv, fv, pay_type) }}

{{ ppmt(rate, period, nper, pv, fv, pay_type) }}