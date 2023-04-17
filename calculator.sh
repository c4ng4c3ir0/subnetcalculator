#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Informe a subnet em CIDR notation como argumento (ex: 192.168.0.0/24)."
    exit 1
fi

subnet=$1

# Calcula o endereço de rede e a máscara a partir da subnet informada
network=$(echo $subnet | cut -d '/' -f 1)
mask=$(echo $subnet | cut -d '/' -f 2)
bits=$(( 32 - mask ))

# Converte o endereço de rede em um array de números
IFS='.' read -r -a network_arr <<< "$network"

# Calcula o número de hosts possíveis na subnet
hosts=$(( 2 ** bits - 2 ))

# Itera sobre todos os IPs na subnet e os exibe
for i in $(seq 0 $(( hosts - 1 ))); do
    # Calcula o próximo endereço IP
    ip=$(printf "%d.%d.%d.%d\n" \
        $(( ${network_arr[0]} + (i >> 24) )) \
        $(( (${network_arr[1]} + (i >> 16)) % 256 )) \
        $(( (${network_arr[2]} + (i >> 8)) % 256 )) \
        $(( (${network_arr[3]} + i) % 256 )) \
    )
    echo $ip
done
