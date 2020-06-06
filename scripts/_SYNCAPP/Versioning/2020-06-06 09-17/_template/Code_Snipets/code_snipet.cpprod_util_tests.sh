[Expert@CORE-G2-Mgmt-1:0]# $CPDIR/bin/cpprod_util
Usage: /opt/CPshrd-R80.20/bin/cpprod_util [-e effective_version] funcname <arg>
   Some of the functions require additional parameter(s),
   some return integer char* or return 0/1 in status
    init                           no-parameter         status-output
    GetFireWall1CurrentVersion     no-parameter         string-output
    GetVersionFwdirFromRegistry    string-parameter     string-output
    GetFwdirFromRegistry           no-parameter         string-output
    SetFireWall1CurrentVersion     string-parameter     status-output
    DeleteFireWall1Version         string-parameter     no-output
    GetSecuRemotedirFromRegistry   no-parameter         string-output
    GetSecuRemoteCurrentVersion    no-parameter         string-output
    GetSecuRemoteLanguageDLL       no-parameter         string-output
    SetSecuRemoteLanguageDLL       string-parameter     no-output
    SetSecuRemoteCurrentVersion    string-parameter     status-output
    CPPROD_GetSilentUninstall      string-parameter     string-output
    FwIsControl                    no-parameter         integer-output
    FwIsFirewallModule             no-parameter         integer-output
    FwIsBridge                     no-parameter         integer-output
    FwIsUnlimit                    no-parameter         integer-output
    FwIsFirewallFirst              no-parameter         integer-output
    FwIsAuth                       no-parameter         integer-output
    FwIsEncryption                 no-parameter         integer-output
    FwIsVlan                       no-parameter         integer-output
    FwIsFloodGate                  no-parameter         integer-output
    FwIsCompression                no-parameter         integer-output
    FwIsFloodGateMgmt              no-parameter         integer-output
    FwIsCompressionMgmt            no-parameter         integer-output
    FwIsFirewallMgmt               no-parameter         integer-output
    FwIsReportingServerMgmt        no-parameter         integer-output
    FwIsLogConsolidatorMgmt        no-parameter         integer-output
    FwIsHighAvail                  no-parameter         integer-output
    FwIsHAManagement               no-parameter         integer-output
    FwIsDuringUpgrade              no-parameter         integer-output
    FwIsStandAlone                 no-parameter         integer-output
    FwIsDoSNMP                     no-parameter         integer-output
    FwIsPrimary                    no-parameter         integer-output
    FwIsFullHA                     no-parameter         integer-output
    FwIsSMCBackup                  no-parameter         integer-output
    FwIsCAFilesFetched             no-parameter         integer-output
    FwIsDAG                        no-parameter         integer-output
    FwIsLogServer                  no-parameter         integer-output
    FwIsFGStandAlone               no-parameter         integer-output
    FwIsFireWallIPv6               no-parameter         integer-output
    FwIsMultik                     no-parameter         integer-output
    FwIsIFWD                       no-parameter         integer-output
    FwIsSMB                        no-parameter         integer-output
    FwIsCrldpInitialized           no-parameter         integer-output
    FwIsAtlasManagement            no-parameter         integer-output
    FwIsAtlasModule                no-parameter         integer-output
    FwIsAtlasCO                    no-parameter         integer-output
    FwIsSecureXL                   no-parameter         integer-output
    FwIsPreviousDAGDef             no-parameter         integer-output
    FwIsStormCenterStartup         no-parameter         integer-output
    FwIsFips                       no-parameter         integer-output
    FwIsSecureXL_SV_Warnings_Disabled no-parameter         integer-output
    FwIsAbacusManagement           no-parameter         integer-output
    FwIsAbacusAnalyzer             no-parameter         integer-output
    FwIsActiveManagement           no-parameter         integer-output
    FwIsProvisioningAgent          no-parameter         integer-output
    FwIsVSX                        no-parameter         integer-output
    FwIsVSJunction                 no-parameter         integer-output
    FwIsVSBridge                   no-parameter         integer-output
    FwIsUsermode                   no-parameter         integer-output
    FwIsNewUSFW                    no-parameter         integer-output
    FwIsUsfwMachine                no-parameter         integer-output
    FwIsUsfwMDT                    no-parameter         integer-output
    FwIsUsfwEpoll                  no-parameter         integer-output
    FwIsUSFW                       no-parameter         integer-output
    FwIsSmallCoresDisable          no-parameter         integer-output
    CPPROD_IsMgmtMachine           no-parameter         integer-output
    CPPROD_IsExpress               no-parameter         integer-output
    CPPROD_IsPnPDisable            no-parameter         integer-output
    CPPROD_IsVPNxAutoStart         no-parameter         integer-output
    CPPROD_IsProdActive            string-parameter     integer-output
    FwSetControl                   integer-parameter    status-output
    FwSetFirewallModule            integer-parameter    status-output
    FwSetBridge                    integer-parameter    status-output
    FwSetUnlimit                   integer-parameter    status-output
    FwSetFirewallFirst             integer-parameter    status-output
    FwSetAuth                      integer-parameter    status-output
    FwSetEncryption                integer-parameter    status-output
    FwSetVlan                      integer-parameter    status-output
    FwSetFloodGate                 integer-parameter    status-output
    FwSetCompression               integer-parameter    status-output
    FwSetFloodGateMgmt             integer-parameter    status-output
    FwSetCompressionMgmt           integer-parameter    status-output
    FwSetFirewallMgmt              integer-parameter    status-output
    FwSetReportingServerMgmt       integer-parameter    status-output
    FwSetLogConsolidatorMgmt       integer-parameter    status-output
    FwSetHighAvail                 integer-parameter    status-output
    FwSetHAManagement              integer-parameter    status-output
    FwSetDuringUpgrade             integer-parameter    status-output
    FwSetStandAlone                integer-parameter    status-output
    FwSetDoSNMP                    integer-parameter    status-output
    FwSetPrimary                   integer-parameter    status-output
    FwSetFullHA                    integer-parameter    status-output
    FwSetSMCBackup                 integer-parameter    status-output
    FwSetCAFilesFetched            integer-parameter    status-output
    FwSetDAG                       integer-parameter    status-output
    FwSetLogServer                 integer-parameter    status-output
    FwSetFGStandAlone              integer-parameter    status-output
    FwSetFireWallIPv6              integer-parameter    status-output
    FwSetMultik                    integer-parameter    status-output
    FwSetIFWD                      integer-parameter    status-output
    FwSetSMB                       integer-parameter    status-output
    FwSetCrldpInitialized          integer-parameter    status-output
    FwSetAtlasManagement           integer-parameter    status-output
    FwSetAtlasModule               integer-parameter    status-output
    FwSetAtlasCO                   integer-parameter    status-output
    FwSetSecureXL                  integer-parameter    status-output
    FwSetPreviousDAGDef            integer-parameter    status-output
    FwSetStormCenterStartup        integer-parameter    status-output
    FwSetFips                      integer-parameter    status-output
    FwSetSecureXL_SV_Warnings_Disabled integer-parameter    status-output
    FwSetAbacusManagement          integer-parameter    status-output
    FwSetAbacusAnalyzer            integer-parameter    status-output
    FwSetActiveManagement          integer-parameter    status-output
    FwSetProvisioningAgent         integer-parameter    status-output
    FwSetVSX                       integer-parameter    no-output
    FwSetUsermode                  integer-parameter    no-output
    FwSetSmallCoresDisable         integer-parameter    no-output
    FwSetUsfwMDT                   integer-parameter    no-output
    FwSetNewUSFW                   integer-parameter    no-output
    FwSetUsfwEpoll                 integer-parameter    no-output
    FwSetUsfwMachine               integer-parameter    no-output
    CPPROD_SetExpress              integer-parameter    status-output
    CPPROD_SetPnPDisable           integer-parameter    status-output
    CPPROD_SetVPNxAutoStart        integer-parameter    status-output
    RtIsRtDb                       no-parameter         integer-output
    RtIsLcE                        no-parameter         integer-output
    RtIsRt                         no-parameter         integer-output
    RtIsLcAddOn                    no-parameter         integer-output
    RtIsAnalyzerServer             no-parameter         integer-output
    RtIsAnalyzerCorrelationUnit    no-parameter         integer-output
    RtIsIpsEventCorrelator         no-parameter         integer-output
    RtIsIpsEventManager            no-parameter         integer-output
    RtSetRtDb                      integer-parameter    status-output
    RtSetLcE                       integer-parameter    status-output
    RtSetRt                        integer-parameter    status-output
    RtSetLcAddOn                   integer-parameter    status-output
    RtSetAnalyzerServer            integer-parameter    status-output
    RtSetAnalyzerCorrelationUnit   integer-parameter    status-output
    RtSetIpsEventCorrelator        integer-parameter    status-output
    RtSetIpsEventManager           integer-parameter    status-output
    FwSetParam                     string+intiger parameters no-output
    FwGetParam                     string-parameter     integer-output
    FwGetIPForwarding              no-parameter         integer-output
    FwSetIPForwarding              integer-parameter    no-output
    CkpIsInstalledFireWall         no-parameter         integer-output
    CkpIsInstalledFloodGate        no-parameter         integer-output
    CkpIsInstalledCompression      no-parameter         integer-output
    CkpIsInstalledSecuRemote       no-parameter         integer-output
    CkpIsInstalledSessionAgent     no-parameter         integer-output
    CkpIsInstalledLoadAgent        no-parameter         integer-output
    CkpIsInstalledReportingServer  no-parameter         integer-output
    CkpIsInstalledLogConsolidatorEngine no-parameter         integer-output
    CkpSetInstalledFireWall        no-parameter         status-output
    CkpSetInstalledFloodGate       no-parameter         status-output
    CkpSetInstalledCompression     no-parameter         status-output
    CkpSetInstalledSecuRemote      no-parameter         status-output
    CkpSetInstalledSessionAgent    no-parameter         status-output
    CkpSetInstalledLoadAgent       no-parameter         status-output
    CkpSetInstalledReportingServer no-parameter         status-output
    CkpSetInstalledLogConsolidatorEngine no-parameter         status-output
    CPPROD_GetCurrentVersion       string-parameter     string-output
    CPPROD_GetPreviousVersion      string-parameter     string-output
    CPPROD_GetCurrentServicePack   string-parameter     string-output
    CPPROD_GetCurrentMSP           string-parameter     string-output
    CPPROD_GetPrevServicePack      string-parameter     string-output
    CPPROD_GetPrevMSP              string-parameter     string-output
    CPPROD_GetCpdir                no-parameter         string-output
    CPPROD_GetProdDir              string-parameter     string-output
    CPPROD_GetShortProdDir         string-parameter     string-output
    CPPROD_GetFwdir                no-parameter         string-output
    CPPROD_GetFgdir                no-parameter         string-output
    CPPROD_IsConfigured            string-parameter     integer-output
    CPPROD_SetConfigured           string-parameter     integer-output
    get_dll_version                string-parameter     string-output
    CPPROD_GetVerText              string-parameter     string-output
    CPPROD_GetPrevVerText          string-parameter     string-output
    CPPROD_GetCpmDir               no-parameter         string-output
    CPPROD_GetCrldpName            no-parameter         string-output
    CPPROD_SetCrldpName            string-parameter     integer-output
    CPPROD_CheckProduct            string-parameter     integer-output
    CPPROD_GetFipsPath             no-parameter         string-output
    CPPROD_SetFipsPath             string-parameter     integer-output
    CPPROD_IsDiskless              no-parameter         integer-output
    CPPROD_is_DA_enabled_on_VSX    no-parameter         integer-output
    CPPROD_is_APPI_or_URLF_enabled_on_VSX no-parameter         integer-output
    CPPROD_is_APPI_enabled_on_VSX  no-parameter         integer-output
    CPPROD_is_URLF_enabled_on_VSX  no-parameter         integer-output
    CPPROD_is_AntiBot_enabled_on_VSX no-parameter         integer-output
    CPPROD_is_AntiVirus_enabled_on_VSX no-parameter         integer-output
    CPPROD_is_IPS_enabled_on_VSX   no-parameter         integer-output
    CPPROD_is_SMAIL_enabled_on_VSX no-parameter         integer-output
    CPPROD_is_MAB_enabled_on_VSX   no-parameter         integer-output
    CPPROD_SetLastMinorVersion     string-parameter     integer-output
    CPPROD_SetPrevMinorVersion     string-parameter     integer-output
    CPPROD_SetLastHFAIndex         string-parameter     integer-output
    CPPROD_SetLastHFARegName       string-parameter     integer-output
    CPPROD_GetLastMinorVersion     no-parameter         string-output
    CPPROD_GetPrevMinorVersion     no-parameter         string-output
    CPPROD_GetLastHFAIndex         string-parameter     string-output
    CPPROD_GetLastHFARegName       string-parameter     string-output
    CPPROD_SetExternalIf           string-parameter     integer-output
    CPPROD_SetInternalIf           string-parameter     integer-output
    CPPROD_SetDMZIf                string-parameter     integer-output
    CPPROD_SetAuxIf                string-parameter     integer-output
    CPPROD_GetExternalIf           no-parameter         string-output
    CPPROD_GetInternalIf           no-parameter         string-output
    CPPROD_GetDMZIf                no-parameter         string-output
    CPPROD_GetAuxIf                no-parameter         string-output
    SetCertPath                    string-parameter     integer-output
    CPPROD_RestoreKey              string-parameter     integer-output
    CPPROD_IsSecurePlatform        no-parameter         integer-output
    CPPROD_IsSecurePlatformPro     no-parameter         integer-output
    CPPROD_IsCrossBeamPlatform     no-parameter         integer-output
    CPPROD_SetSecurePlatformPro    integer-parameter    status-output
    CPPROD_IsPluginActive          string-parameter     integer-output
    UepmIsInstalled                no-parameter         integer-output
    UepmIsPolicyServer             no-parameter         integer-output
    UepmIsEps                      no-parameter         integer-output
    UepmIsRhs                      no-parameter         integer-output
    UepmGetInstallationType        no-parameter         integer-output
    IsSymmetricDSConfigured        no-parameter         integer-output

=======================================================================================================


$CPDIR/bin/cpprod_util UepmIsInstalled
$CPDIR/bin/cpprod_util UepmIsPolicyServer
$CPDIR/bin/cpprod_util UepmIsEps
$CPDIR/bin/cpprod_util UepmIsRhs
$CPDIR/bin/cpprod_util UepmGetInstallationType

$CPDIR/bin/cpprod_util CPPROD_IsMgmtMachine

$CPDIR/bin/cpprod_util RtIsRtDb
$CPDIR/bin/cpprod_util RtIsLcE
$CPDIR/bin/cpprod_util RtIsRt
$CPDIR/bin/cpprod_util RtIsLcAddOn
$CPDIR/bin/cpprod_util RtIsAnalyzerServer
$CPDIR/bin/cpprod_util RtIsAnalyzerCorrelationUnit
$CPDIR/bin/cpprod_util RtIsIpsEventCorrelator
$CPDIR/bin/cpprod_util RtIsIpsEventManager

$CPDIR/bin/cpprod_util RtIsAnalyzerServer
$CPDIR/bin/cpprod_util RtIsAnalyzerCorrelationUnit


$CPDIR/bin/cpprod_util 


$CPDIR/bin/cpprod_util 

