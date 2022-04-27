# one signup and one valid message

set -e


node build/index.js deployVkRegistry && \
node build/index.js setVerifyingKeys -s 10 -i 1 -m 2 -v 2 -b 1 \
    -p ./zkeys/ProcessMessages_10-2-1-2_test.0.zkey \
    -t ./zkeys/TallyVotes_10-1-2_test.0.zkey \
    -k 0x8CdaF0CD259887258Bc13a92C0a6dA92698644C0

node build/index.js create \
    -r 0x8CdaF0CD259887258Bc13a92C0a6dA92698644C0 && \
node ./build/index.js deployPoll -x 0xf204a4Ef082f5c04bB89F7D5E6568B796096735a \
    -pk macipk.c974f4f168b79727ac98bfd53a65ea0b4e45dc2552fe73df9f8b51ebb0930330 \
    -t 20 -g 25 -mv 25 -i 1 -m 2 -b 1 -v 2 && \

# Alice:
# Public key:  macipk.3e7bb2d7f0a1b7e980f1b6f363d1e3b7a12b9ae354c2cd60a9cfa9fd12917391
# Private key: macisk.fd7aa614ec4a82716ffc219c24fd7e7b52a2b63b5afb17e81c22fe21515539c

node ./build/index.js signup \
    -p macipk.3e7bb2d7f0a1b7e980f1b6f363d1e3b7a12b9ae354c2cd60a9cfa9fd12917391 \
    -x 0xf204a4Ef082f5c04bB89F7D5E6568B796096735a && \

node build/index.js publish \
    -p macipk.3e7bb2d7f0a1b7e980f1b6f363d1e3b7a12b9ae354c2cd60a9cfa9fd12917391 \
    -sk macisk.fd7aa614ec4a82716ffc219c24fd7e7b52a2b63b5afb17e81c22fe21515539c \
    -x 0xf204a4Ef082f5c04bB89F7D5E6568B796096735a \
    -i 1 -v 2 -w 2 -n 2 -o 0
node build/index.js publish \
    -p macipk.3e7bb2d7f0a1b7e980f1b6f363d1e3b7a12b9ae354c2cd60a9cfa9fd12917391 \
    -sk macisk.fd7aa614ec4a82716ffc219c24fd7e7b52a2b63b5afb17e81c22fe21515539c \
    -x 0xf204a4Ef082f5c04bB89F7D5E6568B796096735a \
    -i 1 -v 0 -w 3 -n 1 -o 0
node build/index.js publish \
    -p macipk.3e7bb2d7f0a1b7e980f1b6f363d1e3b7a12b9ae354c2cd60a9cfa9fd12917391 \
    -sk macisk.fd7aa614ec4a82716ffc219c24fd7e7b52a2b63b5afb17e81c22fe21515539c \
    -x 0xf204a4Ef082f5c04bB89F7D5E6568B796096735a \
    -i 1 -v 1 -w 2 -n 1 -o 0

# Alice's new key:
# Public key:  macipk.ec1ced99098b6013584784a961eca1ea7de2a707f287bcbde6ccc18cbfce36ae
# Private key: macisk.3ce4d908c6023645e49d05fd1d1e4504eaf66304d28f0c65353ae96888d6193

# node build/index.js publish \
#     -p macipk.ec1ced99098b6013584784a961eca1ea7de2a707f287bcbde6ccc18cbfce36ae \
#     -sk macisk.3ce4d908c6023645e49d05fd1d1e4504eaf66304d28f0c65353ae96888d6193 \
#     -x 0xf204a4Ef082f5c04bB89F7D5E6568B796096735a \
#     -i 1 -v 2 -w 2 -n 2 -o 0



node build/index.js timeTravel -s 30 && \
node build/index.js mergeMessages -x 0xf204a4Ef082f5c04bB89F7D5E6568B796096735a -o 0 && \
node build/index.js mergeSignups -x 0xf204a4Ef082f5c04bB89F7D5E6568B796096735a -o 0 && \
rm -rf proofs tally.json && \
node build/index.js genProofs -x 0xf204a4Ef082f5c04bB89F7D5E6568B796096735a \
    -sk macisk.49953af3585856f539d194b46c82f4ed54ec508fb9b882940cbe68bbc57e59e \
    -o 0 \
    -r ~/rapidsnark/build/prover \
    -wp ./zkeys/ProcessMessages_10-2-1-2_test \
    -wt ./zkeys/TallyVotes_10-1-2_test \
    -zp ./zkeys/ProcessMessages_10-2-1-2_test.0.zkey \
    -zt ./zkeys/TallyVotes_10-1-2_test.0.zkey \
    -t tally.json \
    -f proofs/

cat ./tally.json