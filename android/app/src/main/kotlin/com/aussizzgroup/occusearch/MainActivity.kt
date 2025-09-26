package com.aussizzgroup.occusearch

import android.annotation.SuppressLint
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.Signature
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Debug
import android.provider.MediaStore
import android.util.Base64
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.google.firebase.dynamiclinks.DynamicLink
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import org.json.JSONObject
import java.io.ByteArrayOutputStream
import java.net.URI
import java.net.URL
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.*
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec
import kotlin.system.exitProcess


class MainActivity : FlutterActivity() {

    // JWT ENCRYPTION VARIABLE
    private val channel = "flutter.native/helper"
    val SECRET_KEY = "|<O/|)#\$|<@!2021"
    var cipher: Cipher? = null
    var cipherNew: Cipher? = null
    var secretKey: SecretKeySpec? = null
    var HEADER_JWT_KEY =
        "401b09eab3c013d4ca54922bb802bec8fd5318192b0a75f201d8b3727429090fb337591abd3e44453b954555b7a0812e1081c39b740293f765eae731f5a65ed1"

    // TEMPER DETECTION
    var temper_signature = ""

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val ivParameterSpec = IvParameterSpec(SECRET_KEY.toByteArray())
        secretKey = SecretKeySpec(SECRET_KEY.toByteArray(), "AES")
        this.cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
        this.cipherNew = Cipher.getInstance("AES/CBC/PKCS7Padding")
        cipher?.init(Cipher.ENCRYPT_MODE, secretKey, ivParameterSpec)
        cipherNew?.init(Cipher.ENCRYPT_MODE, secretKey, ivParameterSpec)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            try {
                /// ENCRYPT API REQUEST PARAMETER DATA
                if (call.method == "occusearch_encryptRequest") {
                    if (call.arguments is HashMap<*, *>) {
                        val header: HashMap<String, Any> = call.arguments as HashMap<String, Any>
                        val rootObject = JSONObject()
                        for ((key, value) in header) {
                            rootObject.put(key, value)
                        }
                        println("json object $rootObject")
                        val str = Base64.encodeToString(
                            apiRequestParameterEncryption("$rootObject"),
                            Base64.DEFAULT
                        ).replace("_", "/")
                        //Log.e("token", str)
                        result.success(str)
                    } else if (call.arguments is String) {
                        val rootObject = call.arguments.toString()
                        val str = Base64.encodeToString(
                            apiRequestParameterEncryption(rootObject),
                            Base64.DEFAULT
                        ).replace("_", "/")
                        //Log.e("token", str)
                        result.success(str)
                    }
                    /// [JWT BEARER] Token for Kondesk Web API
                } else if (call.method == "occusearch_encrypt_userEmail") {
                    val header: HashMap<String, Any> = call.arguments as HashMap<String, Any>
                    //Log.e("email", header.get("email").toString())
                    //Log.e("domain", header.get("domain").toString())

                    val str = generateJWTBearerToken(
                        header["email"].toString(),
                        header["domain"].toString()
                    )
                    result.success(str)
                    /// Launch App
                } else if (call.method == "lunchUrl") {
                    val strUrl = call.arguments.toString()
                    Log.e("domain url", strUrl)
                    val intent = Intent(
                        Intent.ACTION_VIEW,
                        Uri.parse(strUrl)
                    )
                    try {
                        startActivity(intent)
                    } catch (ex: ActivityNotFoundException) {
                        Toast.makeText(
                            activity,
                            "Please install Telegram application",
                            Toast.LENGTH_LONG
                        ).show()
                    }
                    /// Temper detection
                } else if (call.method == "guardDebugger") { // TODO:[TEMPER-DETECTION] Put whole code of temper detection in Comments before giving build to QA and after testing uploading the apk in play store uncomment the code.
                    val response = guardDebugger({}, {})
                    result.success(response)
                } else if (call.method == "shareDynamicLink") {
                    val data: HashMap<String, Any> = call.arguments as HashMap<String, Any>
                    //val bytes = call.arguments.toString()
                    // TODO: share dynamic link to particular content, image and link.
                    //val uri: Uri = Uri.parse(bytes)
                    val url: String = data["url"].toString()


                    val appPackage: String = data["package"].toString()

                    shareDynamicLink(url, appPackage)
                } else {
                    result.notImplemented()
                }
            } catch (e: Exception) {
                println("exception $e")
            }
        }

        ///// For Temper Detection /////

        // TODO:[TEMPER-DETECTION] Put whole code of temper detection in Comments before giving build to QA and after testing uploading the apk in play store uncomment the code.
        /*Check if app downloaded from playstore or any other place, if any other place than crash the app*/
/*         verifyInstaller(Installer.GOOGLE_PLAY_STORE)?.let {
             if (it) {
                 print("==> Installed from Store");
             } else {
                 print("Temper-detection is Enable :: Illegal Install");
                 Toast.makeText(
                     null,
                     "Illegal Install",
                     Toast.LENGTH_LONG
                 ).show()
             }
         }

        // For Signature generating of App
        signature()


        //Validate Signature
        if (validateSignature(temper_signature) == Result.VALID) {
            Log.e("signature_check_success", Result.VALID.toString());
        } else {
            Log.e("signature_check_error", Result.INVALID.toString());
            activity.finish();
            exitProcess(0);
        }*/


        try {
            val info = packageManager.getPackageInfo(
                "com.facebook.samples.hellofacebook",
                PackageManager.GET_SIGNATURES
            )
            info?.signatures.orEmpty().forEach { signature ->
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                Log.d("KeyHash:", Base64.encodeToString(md.digest(), Base64.DEFAULT))
            }
        } catch (e: PackageManager.NameNotFoundException) {
        } catch (e: NoSuchAlgorithmException) {
        }

    }

    private fun shareDynamicLink(imageData: String, appPackage: String) {
        try {
            val url = "https://www.aussizzgroup.com/occusearch-update"
            val yourUri: Uri = Uri.parse(imageData)
            /*val yourUri: Uri = Uri.fromFile(imageData);
            val yourUri: Uri = Uri.parse(imageData.toString())*/

            FirebaseDynamicLinks.getInstance().createDynamicLink()
            FirebaseDynamicLinks.getInstance().createDynamicLink()
                .setLink(Uri.parse(url))
                .setNavigationInfoParameters(
                    DynamicLink.NavigationInfoParameters.Builder()
                        .setForcedRedirectEnabled(true).build()
                )
                .setDomainUriPrefix("https://occusearch.page.link")
                .setAndroidParameters(
                    DynamicLink.AndroidParameters.Builder("com.aussizzgroup.occusearch")
                        .build()
                )
                .setIosParameters(
                    DynamicLink.IosParameters.Builder("com.aussizzgroup.occupationsearch")
                        .setAppStoreId("1619089046")
                        //.setFallbackUrl(Uri.parse("https://apps.apple.com/us/app/id1533788153")) // todo: change
                        .build()
                )
                .setSocialMetaTagParameters(
                    DynamicLink.SocialMetaTagParameters.Builder()
                        .setTitle("Shared Title")
                        .setDescription("Description that you will see on whatsapp")
                        .setImageUrl(yourUri) //Your url HERE
                        .build()
                )
                .buildShortDynamicLink()
                .addOnCompleteListener {
                    if (it.isSuccessful) {
                        try {
                            //Short link created
                            val shortLink: Uri =
                                Objects.requireNonNull(it.result).shortLink!!
                            val shareIntent = Intent(Intent.ACTION_SEND)
                            shareIntent.type = "text/plain"
                            val strDescription =
                                ("Hey, \n" +
                                        "\n" +
                                        "The IELTS Reading App is my favourite mobile preparation app. I’ve preparing for IELTS with this app." +
                                        " Why don’t you check out the app and see its features for yourself using this Link \n" +
                                        "$shortLink ").trimIndent()
                            shareIntent.putExtra(Intent.EXTRA_TEXT, strDescription)
                            shareIntent.setPackage(appPackage)
                            try {
                                this.startActivity(shareIntent)
                            } catch (ex: ActivityNotFoundException) {
                                Toast.makeText(
                                    this,
                                    ex.toString(),
                                    Toast.LENGTH_SHORT
                                ).show()
                            }

                        } catch (ex: Exception) {
                            ex.stackTrace
                        }
                    } else {
                        Toast.makeText(
                            activity,
                            it.result.toString(),
                            Toast.LENGTH_SHORT
                        ).show()
                        System.out.println("DynamicLinkResult " + it.result.toString());
                    }
                }
        } catch (e: Exception) {
            e.stackTrace
        }
    }

    fun getImageUri(inContext: Context, inImage: Bitmap): Uri? {
        val bytes = ByteArrayOutputStream()
        inImage.compress(Bitmap.CompressFormat.JPEG, 100, bytes)
        val path: String = MediaStore.Images.Media.insertImage(
            inContext.contentResolver, inImage, "Title", null
        )
        return Uri.parse(path)
    }

    private fun ConvertToUrl(urlStr: String): URL? {
        try {
            var url = URL(urlStr)
            val uri = URI(
                url.protocol, url.userInfo,
                url.host, url.port, url.path,
                url.query, url.ref
            )
            url = uri.toURL()
            return url
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
        return null
    }

    /// [JWT BEARER TOKEN] TO GENERATING
    private fun generateJWTBearerToken(strEmail: String, audience: String): String {

        val calendar: Calendar = Calendar.getInstance()
        calendar.add(Calendar.HOUR, -1)
        calendar.add(Calendar.DATE, 1)
        val expDate: Date = calendar.getTime()

        val nowDate: Date = calendar.getTime()

        val jwt = Jwts.builder()
            .claim("email", strEmail)
            .setIssuer(audience)  // TODO : Later replace this issuer with occusearch project issuer
            .setAudience(audience) // TODO : Later replace this audience with occusearch project audience
            .setSubject(strEmail)
            .setNotBefore(nowDate)
            .setExpiration(expDate)
            .signWith(SignatureAlgorithm.HS512, HEADER_JWT_KEY.toByteArray())
            .compact()

        return jwt
    }

    /// ENCRYPT API REQUEST PARAMETER DATA
    @Throws(Exception::class)
    fun apiRequestParameterEncryption(text: String?): ByteArray? {
        if (text == null || text.isEmpty()) {
            throw Exception("Empty string")
        }
        var encrypted: ByteArray? = null
        encrypted = try {
            println(text)
            cipherNew?.doFinal(text.toByteArray())
        } catch (e: Exception) {
            throw Exception("[encrypt] " + e.message)
        }
        return encrypted
    }

////////////////////////////// [TEMPER DETECTION] ///////////////////////

    /* Temper Detection*/
// TODO:[TEMPER-DETECTION] Put whole code of temper detection in Comments before giving build to QA and after testing uploading the apk in play store uncomment the code.
//Guard Debugger
    fun guardDebugger(error: (() -> Unit) = {}, function: (() -> Unit)): Boolean {
        val isDebuggerAttached = Debug.isDebuggerConnected() || Debug.waitingForDebugger()
        return !isDebuggerAttached
    }

    //Temper Detector for Verify Installer
    private fun verifyInstaller(installer: Installer): Boolean? {
        kotlin.runCatching {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
                return packageManager.getInstallSourceInfo(packageName).installingPackageName?.startsWith(
                    installer.id
                )
            return packageManager.getInstallerPackageName(packageName)?.startsWith(installer.id)
        }
        return null
    }

    //Temper Detector for Validate Signature
    private fun validateSignature(expectedSignature: String): Result {
        getAppSignature(this)?.string()?.let { currentSignature ->
            return if (currentSignature == expectedSignature.trim()) {
                Result.VALID
            } else {
                Result.INVALID
            }
        }
        return Result.UNKNOWN
    }

    @SuppressLint("InlinedApi")
    @Suppress("DEPRECATION")
    private fun getAppSignature(context: Context): Signature? = if (Build.VERSION.SDK_INT < 28) {
        context.packageManager.getPackageInfo(
            context.packageName,
            PackageManager.GET_SIGNING_CERTIFICATES
        ).signatures?.firstOrNull()
    } else {
        context.packageManager.getPackageInfo(
            context.packageName,
            PackageManager.GET_SIGNING_CERTIFICATES
        ).signingInfo?.apkContentsSigners?.firstOrNull()
    }


    private fun Signature.string(): String? = try {
        val signatureBytes = toByteArray()
        val digest = MessageDigest.getInstance("SHA")
        val hash = digest.digest(signatureBytes)
        Base64.encodeToString(hash, Base64.NO_WRAP)
    } catch (exception: Exception) {
        null
    }

    /* For App Signature generating */
    private fun signature(): String {
        val info: PackageInfo
        try {
            info = packageManager.getPackageInfo(
                packageName,
                PackageManager.GET_SIGNATURES
            )
            for (signature in info.signatures!!) {
                val md: MessageDigest = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                temper_signature = String(Base64.encode(md.digest(), 0))
                //String something = new String(Base64.encodeBytes(md.digest()));
            }
        } catch (e1: PackageManager.NameNotFoundException) {
            Log.e("name not found", e1.toString())
        } catch (e: NoSuchAlgorithmException) {
            Log.e("no such an algorithm", e.toString())
        } catch (e: java.lang.Exception) {
            Log.e("exception", e.toString())
        }
        return temper_signature;
    }

/////////////////////////////////////////////////////////////////////////////

}

enum class Installer(val id: String) {
    GOOGLE_PLAY_STORE(id = "com.android.vending"),
    AMAZON_APP_STORE(id = "com.amazon.venezia")
}

enum class Result {
    VALID,
    INVALID,
    UNKNOWN
}
