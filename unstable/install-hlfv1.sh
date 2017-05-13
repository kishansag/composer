(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �.Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/������|�tN7n�O��/�i� h�<^Q�D^���Q��0�"�/�c$��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.���J�e�5�ߖ��2.�?�Uɿ�Y���4��%)���P�wo{�{�l�\�Z�9�%���}��S���p������_��k�?�xv���'=�(`� ����Z�{��\@P����|R�N�i����(>F�i�v1w��<��)��Q��Q�b��q�e����Q��HsmǣHE��o�Ϛ{~�2���x���$����X��K)c �p�u'6d�&�B�z�lC��E�T)M��(�2�I}a,0���F)�[e�ւ6U�	�e���i�ϯ}�`!���x�	Z��Աc���#��sݧ(��h��:���OYz8�l%�n���Ri&������Ł��"�-T?�%�^|��}��:+��K_��������M���������j��|���*��o�?z��W�?J����Xe�K��ϋ�!K2_��[�/�|��y�vC��eMYJ|2�{[f���-�e�6���|��i� f\�hY�%����98��R<��甶�I�=o݈L,C*�v��v�:���,���5$g�H�9QW s��D�݆�p��~|w�z\��P��-ƣVύܝ�#H0D\�\9^���H0�Lޫ����Ď��L�4��x :t�sh�su�4���6�P�I308׹�`uS��F���c�{q ~�-]̅�4.��O����xk��X��?�&��B�7�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��'�"�xy2��4��������5���'�K
P80y�(r�r�,��t�1)m�&Fv��Ê	��R=0�6H�\�h�D�i��.C!J !P�/k<y:9�����	t	#.b�fu0���n����ڹr�Iڒ�hj�x1��C&K f�ȱh�sfы��(�e��f�߭�����6�@�������|���?�^��)�c(EV�_^�qV�����#ü�ީ��.Yo	$��-����9ǉP�1�%�
��Q�N����٩pP��*�*HvQVp?�+3��L�� ��,,LCѕ�.�,�`w�8b�N��(��K�T�s԰�D�/['RS�w�й[��n�Ǯ�{E��bn5o���P �{-C���O�e�Y�l�S�r!<QuhM���ãr����)gF���U ���@��O7�q���1�����8�t�܇�.��w|K3ymJ
�(�Hs?�4���\rآQ�R�l�9��L�k|'p$�,���&��/�D�p����t��<�1>�@��亖L��)�fV}ȡ�a��?����k������$IW���C������{��F����@�W������/��7�^��J����_��g��T�_)�����_�ҧ� 'Q���f������); 	h�e0�u
=�%�q�#�*���B�%��A�JQx�����vO��M
Zy8�XOP�Yǳ�>WD�qpa��Q��Ë�?k�؂m�
f�dܐ����[&_z˖2�'�!rXm|�1�>��:ݎ,h��ܘ��%���_�[P�	v��lO�*���%�����*��|��?<���������j��Z�{��������K���Q����T�_)x[�����{3��#�C��)���h��t��>����c����n�]���� ���&s�P�\��#�.�CL2����ܚ�=���a�|�P��I��N���lXo&�w�A�1hJ�x\(�R��;Y�c옞�'Zט#m�G��lp�H:����9;'�8���c� N��9aH΁ ҳo��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2iBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K��3�Њ������3�*�/U�_��U����o�����#�.��+�/�����?F�d��������+��s��w��C�Ǿ �%H��W.���I/�~�a04�|�!��� <g]�܂���o�E�E��Y�fI���,��e����?�����+���L���j�*�7�[c�`��Ǟ#���~����� ���P�;aw괒RCCrG�v��|�a�' �؍r��*mw;p{G��=1@<Z���&#���9���n7���ލ�����~����(MT������^��S�߱�CU������2�p������R�^�?(�}��q�\�4^TW�/)����^,��j�o)��0}���������?K#t������6�26�R��Q��,��x4B��x���o���BQi(C���������j���q��O���>H-�j7���X&��\=V�k��������Հ&\xٮ��sX]W|.E�T�;��ͣ�L8�u>ʼf$���-�?����!�V�g"�	���� ����֫��w�#��������H���J�����$���������'����K��*��2��������o!��(�����_����΁X�qе�x�%,�!?;�y<���%�������a�'Ui��%U��n�/���CwA�����h�� ���=�Z�a��=
'���N1��+ݥ����A?�$��}�؄q��1r-��f��Ex�p�LNp�ɬ'��x��bs5�9jo�EsI�٠��`�uF9��z��2<�Q&�=b��Mb����k�Mba΅�x|�s�[SW�m��Dk�
?o@���P�r<����T���xl�A�Z�n�yP�:#���6\����`t�A�	NSΦ�4o���7�ڊlt��H�,�e�S����Ӷ7���{@��p��f�	zR.�do��l��-�U].��x�4���������������K��_~���+��o����j�0�D������@����R������6���z��ps'���B�ó�ч���w���3G�Al�<���� o�2|�zO��0j����&>	[��O΃���ɡ���-*�;��5Y/��Z�o�JOM���C|k�r�Z��0�SٌI2��u��(�Z"��r��դ��y��!�~��݇.���� ��Y>h��@�Dk�<�w�u7��+e0��j.uq�?%s9��V{f��!Wk����=h�t�0B��G�P��a�?������/q��_4���J�o�����?��?%�3��Z�����k�����2P��W�������F���S`.��1�~��\.�˽����P���,�W�_��������E=_��~��\���G�4�a(�R�C�,�2��`���h��.��>J8d��T��>B�.�8�W���V(C���?:��B���Rp����Lɖ�þeN�6;}�!Bs�m�me�E��#mѢ&/��1ќ��J;�����(���)�G�  �mow���c�o]�5�Oaz���z8#P�249�P�7�+u�Ŧ=4����^������(�3�z->�?�Gȧ�Ea��e`�Ya��������O�S�ϾB��k#�K�6����Z��?]�^X�c`;�Խr��;����+��F��E2�O���i/#�>ߤV��I��e��7ͮ"~�����W�~���I�����������?�:�7����Z6�]����ޣv�vU�\W+��¯���'�}_�8�h��/����W�rj�_O�&�_�+�4�x���ct_r��׷~���^����Oo�vT�
׾��T4��ng���w��L��fͭ�.����4DU�A�#�Q�����7�������k_�+���
ߎ�}��$w~0������<��0���*�΢��/w�˃����·��śW[���Q��9l/����o���:b�]�E��=��e҂H�?m��w������{=�~�;}����n��A��~+�^{��\c�-���rQk�a�������|�o�i������^O�,u�p��l���d�@�I�ު=,|b	�!�##p6�U�n�>j������gd���0��<��^��6���7|�*��q$�C4dE��o��y�VGƷu���J�3B�+�Ʒ�r��
��$����N�t��Ϟ�u�P�O���o�jc\��t{����Ko��Xnz�z����8N�Rǉ���$�w�Tw=�c'qb���
������X��hA��$�~��?��]�Jh�PW-�E+?�c'�$�d&3�ޖ�s�;�����s^�~�9Po�i���%Xl:��&6�\�%��6�B�,�NщX���WÃ�tE�X:�Kdn���d��ֶ�3P�<I�����`_F�)2iwݱ��ӢĢ[��4У@��ׄ�c2/�bnrN(�����ՕEW]Uu ��e�ݮ��tM� C#Ԛxh�K�X�hv)� `-���5a�����G����j�M���cS�4g���̰ztI�#i���O�����/��-���[5�����+ĻE�3o��1�`毙gnN��zhN#��[T)�7���Ѷ�������)�PZ����UGM��N͸=t��l/j���z4���h�
C^�h����;�������g����p�}Ep:;1�Ӏ՝�#Z����� vv����#IW{�ڪ�~��������)�Nk��{Nj��/ltSi6�6aq������;�i���rû숂��]5_���PFV&:�t^3��?��ǣ5��fVa
���E[Y\}8-��B�i�}l�2��"�����L)��m�~�cr]�	EnZ��j���������ϒP��W[�В���^��#׎��B����͖tM�pc�Q��;��<8r�@#�O�*�=��X��֑��2�1pYB�N�8�e���ے�e���i]<�F��M�����R-vF�U{M6|e�*������.l}��>G�����]����Og�V��l�4��^_!8<��7h�����ժ���?^���g��n���|�y��E<J[v.m��O���]�{l����>V�=>O=���C<��ǃ�`��~^�C�߷��=pT 5�'1�'����hz��շw_z�����������_n=��D~���pX����np�4�|ݍ��a ����|�x�y��5�א�][����'�Â��}v��� ^ܕ��ts��7��<0!瑃�,�ؼ0`���oR�$^뜴x�I���� BaFV�����C���a!� �v�U�һt�&RU����85��^�,�Խ��J]�]��:(��@V��A4�,],��8�k���}�6sK�d�$�Q$os��[���"����0*0�Va�h|@Ȇ8̲y6<�.1�*l�'g«d�1����R$�͏�Z���)K:�T��F3_0R�U)�j���zGJHi�ȣᴁJ)c���*��ň��=��i��Y�0dU+Ǒ��/_r���a�nE�|"��GL�e�E��ܦ�a�M=�)�5?��f����Ss#dݫG��F<���1/��Nz��P.��w��~Uh&Uth$1P�Ź0^(Ҹ�vZ�5О��r.J�[�h1�� ��!+͍{\�V3(�A� ��r<��)t	Y�/�N�,!+ً������dCu���U�b�ˍr5���@���O6�$�r��j��P��B=�N���~*Y�Ԓ�q��		.v�6����D�IY�l���,{��n�?�%�ZI�Q�x��Z��c	+�^rB'-�{�x��:�Z�%ʙ��f¥$#{�Z'c
UmT�}�t�Br
[4�
c��L0,��"��(�%e9"� �VY⺏��C<Ӕ�l�ī��A����y_4�fe��e4�������{XXgұF+��jqP����DJ
u�"��VY��e�BY��+Kse�㉁�1�W�8M{�<�R�<���؛�zc�]�/~4�eE�C��ң�/�{�nj\���dK8��Q,���PS��)KTN7��(F�q=TUA��2�l�*pؒ�^�]�,\d���8���Ɛ�*����Q�����SR��Oy��n	p�nK�Tzh�u�K)ŀ����X>-��6Jy}�r���,n�gs|6�g��g۹D�?Í��Kz�+��.��֝���\�/lݱsy�������G��e�>�g�2�g�����"_;UU;� o�]A6C�j��܏����=m�y\�t���Q��0B@���� j]RQ&'wP��BV4�z���a [sU�K�3b����&"��%p�P�q�{���cyryl?�̷���<�o�mw�U��֛0��}������"�4jVˑ�"�B�{��1W��m���ļ��)�+��up��4��
����1+V��)��A�� �����@��U �]V$}������D��?���y��6�ۇ�9/�K��/ϝ8tOL���Қ�Z�(��P������KJ�𠭎����h.:�Ok��xX���6]p�rd����κ��U��4�5gс<8�,DJLE�>���ޘ�UZ�2��}|L#b���\(+��VpLu�X<���0��h�/��R��Q��*E���t�MB%�,��5��Y��؃�a�If�d1A��2���19}3�Y����p�D4�j(��A��{��\||@�=�NjL�\�@s�D�#�@V,�	Ez@-������*�G}X��|�i����x82�x/$�AB
wd}�f0���P�vK��B���j4��8.5�� ��c����c�q���z��G��A��s��e��:&�9f>ӆ90۳{y
>8��^䲝���yX�=,����x�x�{[<,'��Ɖ�m:���#|����j�ԅ4o~~D,)����9,Py����6��A�YL�5(2k�E�5gY���0�ryg�����"�v��#tX�c���݌!�O�ZG���zBɪ֧�V�`�����qt4�h��Q0&!E��`��X8m0�0B���E��}��b���q߁��p����'U�w1\Ԇ����E���rU�zcR�)�~%S#Ӣ.U�1��R3�ǃ(��������!��-x ��ӢQmV
�~��&=�f���]�yc�1�8�ތ�Tޏw1ⷑS�=�S��c���F!��l;7��V�.�w�8oȍ����=��ӭh��_`�oN|{�$k5]4р�v�w��k�_��BIER�-�mA���\����ܨWY���M���"r��vso���ˏ�����z?����/~��{��^��s~r��ou���k�ws�bZ9Q���8�������8��ے�{��կ�׷�b�/���7�a���O&x�3����d�k�w�_D�=	��_L� xp�N�~hqE/wEc2��QCv���K~���������Cy�?�}�ŗ�����y�7x�A~� ���v�̍��H���C�t���ӡ	84���|�}��u�N@ڡv:�N����l���z�v��oy��7NA�܄W)3���M�m�@޶�:�x��s���31t���!~�:��5���8n��3p>�:�R��c�q�f<�3p$���d��zin��:O˙3�D[�93δ gZ�3g�1�8nÜ�3��=���13��y��NZ۔���Gϑ�y^�R�����Nr�����m�+���  