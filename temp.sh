<?xml version="1.0" encoding="utf-8"?>
<!-- $Revision$ -->
<appendix xml:id="ibase.constants" xmlns="http://docbook.org/ns/docbook">
 &reftitle.constants;
 &extension.constants;
 <para>
  The following constants can be passed to <function>ibase_trans</function>
  to specify transaction behaviour.
  <table>
   <title>Firebird/InterBase transaction flags</title>
    <tgroup cols="2">
     <thead>
      <row>
       <entry>Constant</entry>
       <entry>Description</entry>
      </row>
     </thead>
     <tbody>
      <row>
       <entry>IBASE_DEFAULT</entry>
       <entry>
       The default transaction settings are to be used. This default is
       determined by the client library, which defines it as
       IBASE_WRITE|IBASE_CONCURRENCY|IBASE_WAIT in most cases.</entry>
      </row>
      <row>
       <entry>IBASE_READ</entry>
       <entry>Starts a read-only transaction.</entry>
      </row>
      <row>
       <entry>IBASE_WRITE</entry>
       <entry>Starts a read-write transaction.</entry>
      </row>
      <row>
       <entry>IBASE_CONSISTENCY</entry>
       <entry>Starts a transaction with the isolation level set to
       'consistency', which means the transaction cannot read from tables
       that are being modified by other concurrent transactions.</entry>
      </row>
      <row>
       <entry>IBASE_CONCURRENCY</entry>
       <entry>Starts a transaction with the isolation level set to
       'concurrency' (or 'snapshot'), which means the transaction 
       has access to all tables, but cannot see changes that were committed
       by other transactions after the transaction was started.</entry>
      </row>
      <row>
       <entry>IBASE_COMMITTED</entry>
       <entry>Starts a transaction with the isolation level set to
       'read committed'. This flag should be combined with either
       <constant></constant> or 
       <constant></constant>. This isolation level
       allows access to changes that were committed after the transaction
       was started. If <constant></constant> was
       specified, only the latest version of a row can be read. If 
       <constant></constant> was specified, a row can
       even be read when a modification to it is pending in a concurrent
       transaction.
      </entry>
      </row>
      <row>
       <entry>IBASE_WAIT</entry>
       <entry>Indicated that a transaction should wait and retry when a
       conflict occurs.</entry>
      </row>
      <row>
       <entry>IBASE_NOWAIT</entry>
       <entry>Indicated that a transaction should fail immediately when a
       conflict occurs.</entry>
      </row>
     </tbody>
    </tgroup>
  </table>
 </para>
 
 <para>
  The following constants can be passed to <function>ibase_fetch_row</function>,
  <function>ibase_fetch_assoc</function> or <function>ibase_fetch_object</function>
  to specify fetch behaviour.
  <table>
   <title>Firebird/InterBase fetch flags</title>
    <tgroup cols="2">
     <thead>
      <row>
       <entry>Constant</entry>
       <entry>Description</entry>
      </row>
     </thead>
     <tbody>
      <row>
       <entry>IBASE_FETCH_BLOBS</entry>
       <entry>Also available as <constant></constant>for backward
       compatibility. Causes BLOB contents to be fetched inline, instead of 
       being fetched as BLOB identifiers.</entry>
      </row>
      <row>
       <entry>IBASE_FETCH_ARRAYS</entry>
       <entry>Causes arrays to be fetched inline. Otherwise, array
       identifiers are returned. Array identifiers can only be used as
       arguments to INSERT operations, as no functions to handle array
       identifiers are currently available.
       </entry>
      </row>
      <row>
       <entry>IBASE_UNIXTIME</entry>
       <entry>Causes date and time fields not to be returned as strings,
       but as UNIX timestamps (the number of seconds since the epoch, which
       is 1-Jan-1970 0:00 UTC). Might be problematic if used with dates
       before 1970 on some systems.
       </entry>
      </row>
     </tbody>
    </tgroup>
  </table>
 </para>
 <para>
  The following constants are used to pass requests and options to the service
  API functions (<function>ibase_server_info</function>, <function>ibase_db_info</function>,
  <function>ibase_backup</function>, <function>ibase_restore</function>
  and <function>ibase_maintain_db</function>). Please refer to
  the Firebird/InterBase manuals for the meaning of these options.
  <variablelist>
   <varlistentry xml:id="constant.ibase-bkp-ignore-checksums">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_backup</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-bkp-ignore-limbo">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_backup</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-bkp-metadata-only">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_backup</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-bkp-no-garbage-collect">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_backup</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-bkp-old-descriptions">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_backup</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-bkp-non-transportable">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_backup</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-bkp-convert">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      Options to <function>ibase_backup</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-res-deactivate-idx">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_restore</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-res-no-shadow">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_restore</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-res-no-validity">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_restore</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-res-one-at-a-time">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_restore</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-res-replace">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-res-create">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_restore</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-res-use-all-space">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      Options to <function>ibase_restore</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-page-buffers">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-sweep-interval">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-shutdown-db">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-deny-new-transactions">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-deny-new-attachments">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-reserve-space">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-res-use-full">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-res">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-write-mode">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-wm-async">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-wm-sync">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-access-mode">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-am-readonly">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-am-readwrite">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-set-sql-dialect">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-activate">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-prp-db-online">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-rpr-check-db">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-rpr-ignore-checksum">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-rpr-kill-shadows">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-rpr-mend-db">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-rpr-validate-db">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-rpr-full">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-rpr-sweep-db">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_maintain_db</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-sts-data-pages">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-sts-db-log">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-sts-hdr-pages">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-sts-idx-pages">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-sts-sys-relations">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_db_info</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-svc-server-version">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_server_info</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-svc-implementation">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_server_info</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-svc-get-env">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_server_info</function>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-svc-get-env-lock">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-svc-get-env-msg">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-svc-user-dbpath">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-svc-svr-db-info">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
      </simpara>
    </listitem>
   </varlistentry>
   <varlistentry xml:id="constant.ibase-svc-get-users">
    <term>
      <constant></constant>
    </term>
    <listitem>
      <simpara>
       Options to <function>ibase_server_info</function>
      </simpara>
    </listitem>
   </varlistentry>
  </variablelist>
  </para>         
</appendix>

<!-- Keep this comment at the end of the file
Local variables:
mode: sgml
sgml-omittag:t
sgml-shorttag:t
sgml-minimize-attributes:nil
sgml-always-quote-attributes:t
sgml-indent-step:1
sgml-indent-data:t
indent-tabs-mode:nil
sgml-parent-document:nil
sgml-default-dtd-file:"~/.phpdoc/manual.ced"
sgml-exposed-tags:nil
sgml-local-catalogs:nil
sgml-local-ecat-files:nil
End:
vim600: syn=xml fen fdm=syntax fdl=2 si
vim: et tw=78 syn=sgml
vi: ts=1 sw=1
-->