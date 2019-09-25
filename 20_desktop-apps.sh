#!/usr/bin/env bash

cd `dirname $0`

echo "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.7 (GNU/Linux)

mQENBFYxWIwBCADAKoZhZlJxGNGWzqV+1OG1xiQeoowKhssGAKvd+buXCGISZJwT
LXZqIcIiLP7pqdcZWtE9bSc7yBY2MalDp9Liu0KekywQ6VVX1T72NPf5Ev6x6DLV
7aVWsCzUAF+eb7DC9fPuFLEdxmOEYoPjzrQ7cCnSV4JQxAqhU4T6OjbvRazGl3ag
OeizPXmRljMtUUttHQZnRhtlzkmwIrUivbfFPD+fEoHJ1+uIdfOzZX8/oKHKLe2j
H632kvsNzJFlROVvGLYAk2WRcLu+RjjggixhwiB+Mu/A8Tf4V6b+YppS44q8EvVr
M+QvY7LNSOffSO6Slsy9oisGTdfE39nC7pVRABEBAAG0N01pY3Jvc29mdCAoUmVs
ZWFzZSBzaWduaW5nKSA8Z3Bnc2VjdXJpdHlAbWljcm9zb2Z0LmNvbT6JATUEEwEC
AB8FAlYxWIwCGwMGCwkIBwMCBBUCCAMDFgIBAh4BAheAAAoJEOs+lK2+EinPGpsH
/32vKy29Hg51H9dfFJMx0/a/F+5vKeCeVqimvyTM04C+XENNuSbYZ3eRPHGHFLqe
MNGxsfb7C7ZxEeW7J/vSzRgHxm7ZvESisUYRFq2sgkJ+HFERNrqfci45bdhmrUsy
7SWw9ybxdFOkuQoyKD3tBmiGfONQMlBaOMWdAsic965rvJsd5zYaZZFI1UwTkFXV
KJt3bp3Ngn1vEYXwijGTa+FXz6GLHueJwF0I7ug34DgUkAFvAs8Hacr2DRYxL5RJ
XdNgj4Jd2/g6T9InmWT0hASljur+dJnzNiNCkbn9KbX7J/qK1IbR8y560yRmFsU+
NdCFTW7wY0Fb1fWJ+/KTsC4=
=J6gs
-----END PGP PUBLIC KEY BLOCK-----
" | gpg --dearmor > /tmp/microsoft.gpg
sudo cp /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

sudo tee /etc/apt/sources.list.d/vscode.list << EOF
### THIS FILE IS AUTOMATICALLY CONFIGURED ###
# You may comment out this entry, but any other modifications may be lost.
deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main
EOF

echo '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

mQINBFo0Ix8BEADWFvFinBKSD+0OTCGrY4F+GxdXdZm3tCT0YxSc54phh6JaDGvs
7gkNYNl4nbGPMK7jfN0X859BOFqBUUZ7A49C3fMVtjT7Q5SIrRCRyuHxy+RHs/gi
1+veNxJU5kQLM2RHC0kzOFczGc83JJvuyecDLfRp9DzpgNFG8BunazByfqz5WhFu
J4Q0WqA2AiQjs8J4zkwlbKoA7x5y315vP8k166vPn29WwuD6UZ2I+pjTi61Mk9KY
j7oT1IYgZRajL+vf1kcrAxBJUhG+bWQ/mJYcV+cSqnza9L/EHKQBbPL6Yi06vr5s
M169D7L49RXH7G6Rha6R1RrH9ENYynuEP5xBG7dUv/7ufg8hCti/bKY+d3cc2lGl
zsgLIkYoKz9ZtjcYhuWe+jEiop6iQtdCJyGq+CTKoCHmKExfHaiqoOTPCpLDjqhh
perorH9DCwm8isQuL1yiIzAsnqeoN5NoWYBXNen6VLDKmnrM2FbeuYvXOiO7c7s1
tYV3Z38yuK1sC9ATV5USJmFDpHX82/c2EesBs2Uuni6ZyxfyzvfIZDJ1PTtAaH/8
FiMnMgFqxchRaGdgYbGrnUogy6bWL6EuGSKN8AFob/420X8R+T/Fl/Y1kc3JKLSI
yMAvemy6qyhY7sOTO/EogdDTVuPcribWkf/H0AUS7evagW7bNJ2v5U712QARAQAB
tGxodHRwczovL3BhY2thZ2VjbG91ZC5pby9BdG9tRWRpdG9yL2F0b20gKGh0dHBz
Oi8vcGFja2FnZWNsb3VkLmlvL2RvY3MjZ3BnX3NpZ25pbmcpIDxzdXBwb3J0QHBh
Y2thZ2VjbG91ZC5pbz6JAjgEEwECACIFAlo0Ix8CGy8GCwkIBwMCBhUIAgkKCwQW
AgMBAh4BAheAAAoJELdUQrvenjsJd/oP/jlEog4KpCehu5D4nkpJ/JSQF4By/E7n
MoylSK4CjOk4ztUC6q5On+4HWjNXB+XMdncIBkzg7pPNc89B6B/0UVO0kztH+p1I
T2FH7QbWHw/+YHvJiIpdvztKKMEzKxuwBt9t67nIaTpQZXRPsGHExd/ber22nHMs
6lGD4HQs4N76cCHZKOW6Ybi1w+GNQK9roUM9t4BbQ8tIQRoVTVsN2TOi7470v/Z1
rNTr0LDzZUvWndQfvL+GBeph8m9nLUJ5ZQfjyWKyk5/g67LY3hasP6OYcRTTFb8s
B0dF4vWZoxz2tUk5bmcwCJb5GkxAwPRpd1Okg8pfxnNXLg/4td4Wcw4GUIYHFQU7
8FofqqVJo/8+W25FyQCuwM1U02nz6SSTTWd4oZn05KuBGf9uPVkPc7zhQYAq9VVK
kjgALG8cC0FI8ExQ7yMVsgUXi1kxDvhKR3cRX1BiOHfrRw6rCzzUI9S9Kaheei49
g3/rbTCRQuTMshJjwfHRi5n6kj8rh+ulXLXqItYqFqbt0eTZvnlPlfYzb8umxdbf
05/vlHw2mndFOrnoaipkS3PITtNX0dt+2lRtS6Rz/Lj582YjrN7DnPblZJ8iOqN/
umZgItrwbCWA+BwhO8SaYgYebs3I7tD1WJlFahTaj2iY4FIBgvQ7wGS4k4AssZGR
3QUkVMX9gqXcuQINBFo0Ix8BEADDXqPw8iOeckSKwNOgwAl+R65+Cw0kOvILDfv4
U5a+/bZsXEPU7wD8mHhFra0wpewxZvMe5I43Cy90b0S8Fmvq5b946aH6jvCkWinQ
eVYpPtnrBu5oI/mh0j+0U3jei5NMZj4anXhf9LdcMstPmAZ7y0YpJqu3X0NgCpWm
r6ZLFKQL8VjtcA5dsa0YRPUuwixJvHBVuajz3TG6HnWDxrdl+6f/mXh5HoRDHKn1
AYK+LsBsaP95XBc4AVGCQx1m+2QPfvvd21EE3Um0NAwVWSAMjClJE1kmRunOV6wz
6C+EJsDW3uXFDGPc9yFHF4ku0mezVvpGfiRdI4BBKqgOIlFkX01hdC48UNkx39tm
jHMhEsoemuPtH6d5fxej8YYFjuxUJNZldx868asOexsFhKFnZu+Pew7lAS6iVwOp
ac05zRqDDnGhZxZVXPdNpu2YXqpDnjoZwJZuXyrRve5RrZC7By6Jw8NlY4bJRRrN
cCuvyYN7R2fhar0rr3iT6IlNC63Gn5mdAvYbsmTjbvMKdQrwdlLz7ghK43cfuBNz
ypQqgxb+1+Aof9/ncijkOamdzkwIFbuEGJije/x8J+v3uaEMkzyKZEGu3aVeYL9v
ajthviY08xMlBjUJ4BgmGqPpmRGIC61lNmWWWSv0QmXRG0QD1GjmnigSyHqbzjgY
pujrjQARAQABiQQ+BBgBAgAJBQJaNCMfAhsuAikJELdUQrvenjsJwV0gBBkBAgAG
BQJaNCMfAAoJEExudNbAo1EI85UP/2+EaThEuatE+rGxZwffldxoeueAr5a00lRr
wt6YHG7ThDAjD2p79aUHd+QvvMEY8dbEDXUwAURN81/yw4WdjhA6xKK/O/gvV34N
9fuuo/1WeemiDZp94X4gsfbFlaGIB6SvbGsHkTOhFxK1uv5wRzDqWt3Z05qUpBcJ
nWMH9kX4cnusxKp+4x27f5tLLoH55f5/n4qNDgfMzvn2GgT8q5Vs8fnQZUPKMUIw
DWBpQedNzvBonkM5XxGyi6kPGnFBzZQnWphG6MCbmiS+/nufy5hDfgkOgj9lUuXZ
KhB+l2SadC/onwHDomJDXoc7TuM+HszZpPNtzQJCceQMsTQyWreveAjDDDLKCrZd
Tl5Driq9oYhjSTdyaVBWBu3SXSwpyuYvfxVePAWVLXVYW2oWEnkmZEEzf8Yo89kC
Ks0+5QwyQ39GvFYhn+mKfBWzM8zx/HZoWBC9umJMS5xDvSBmJGla2NPgWXBiar4g
RecDJGixQV5KWNfVvFfHT865DrKZEnKU82iogSfk1VXoiF0ZavNbEYdr3jwOua82
B19SxZ7tsl61tV8bTwWIs0c3IjnsPrMbHWeEC2zetWIBJ119dK61v8P++bvwT2tb
FNyXkR1+MSl4xYOx6XP8nv8xEIgaJGRWZzijb/7LTY58ZyDsfkrM8ostxKjl7wLu
5YwS0VMwrgAP/j+SXe4vk8AvbY3zx0B9M5UT1unZpBPQa0q4oUNs8ADVIcHebsya
l17CrW7755UrBWxi44cFNiM8fJLd+Q55LKWk8R4D0/q9x9kVkyARMuFEfSvBfr07
g//ky1jTYXq3yzn9h4GEZsf2gYVIGwLoHnrCU/35ChG+lS6VmlS2IL3fbLpC+yzS
Y/9CJhQSGMGtqHhJ3fCNY+0Q+PeabJQj4kz8+qJAZCgCeHOVZQ81mRZ6Leyj3Y5y
okmN6lkT4xrYeIKDVjo8sK9yE3U/HNklIupol9WbIewoitDTG0Ob55cYcYm/IHWn
UeE9xbsVW6h9DlecBNwR4U1XCCrNpCHa4eqcX+WVy3JLTrssTcxDJuZaGeltykpU
lVEm7n6LTL8xSIl/WFon3IxP0Avxwa6hsikoR43VdO0OOZUdhY3kDtYa4JcBZ9Ga
zP0W9aOjqjSzIM+A9QOx41S2ugHI006PFMj+4ON+aisJgxoFeuZIXQDDvDognX0a
z2PiG8U/1G4rcGyRaYbh0YA2GzsM9iGLds7YaMRGhMDytNqZOairMdZJRc5u7x4i
Md1AC6VBgFkelmdqGxyFIFqL3OjzgnCA5xjtKyHctxUldkIVPB/Tuso2pWeybzbt
geP9xVV2t32y5Vnm184J09woo9YPSkdHtwhACy8KUFjcTr+gPK4MuDPi
=xIV1
-----END PGP PUBLIC KEY BLOCK-----
' | sudo apt-key add -
sudo tee /etc/apt/sources.list.d/atom.list << EOF
deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main
EOF

sudo cp ./files/sogou-archive-keyring.gpg /etc/apt/trusted.gpg.d/sogou-archive-keyring.gpg
sudo tee /etc/apt/sources.list.d/sogoupinyin.list << EOF
deb http://archive.ubuntukylin.com:10006/ubuntukylin xenial main
EOF

sudo add-apt-repository -y ppa:webupd8team/terminix
sudo apt-add-repository -y ppa:mc3man/older
sudo apt-get update
sudo apt-get install -y tilix gedit gedit-common sogoupinyin
sudo apt-get install -y atom code

cd /etc/profile.d && sudo ln -s vte-2.91.sh vte.sh
cd -

if [ -z "$(grep 'vte.sh' /etc/skel/.bashrc 2>/dev/null)" ]; then
  sudo tee -a /etc/skel/.bashrc << EOF

if [ \$TILIX_ID ] || [ \$VTE_VERSION ]; then
  . /etc/profile.d/vte.sh
fi

EOF
fi

sudo tee /usr/share/glib-2.0/schemas/50_tilix.gschema.override << EOF
[com.gexperts.Tilix]
warn-vte-config-issue = false

[com.gexperts.Tilix.Settings]
terminal-title-style = 'none'
app-title = '\${appName}\${activeTerminalTitle} [\${columns}x\${rows}]'
prompt-on-close-process = false

[com.gexperts.Tilix.Profile]
default-size-columns = 150
default-size-rows = 50
show-scrollbar = false
EOF

sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
