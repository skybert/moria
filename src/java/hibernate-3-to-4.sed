# Performs a very first, rough migration of Hibernate 3 to Hibernate 4
# in Java, Spring and POMf-files.
#
# by torstein.k.johansen at gmail.com
#
# Usage:
# $ find -type f -name "*.java" -o -name "*.xml" \
#        -exec sed -i -f /path/to/migrate-from-hibernate-3-to-4.sed {} \;

############################################
## Maven dependencies
############################################
s#<artifactId>hibernate</artifactId>#<artifactId>hibernate-core</artifactId>#

############################################
## Hibernate methods
############################################
s#nullSafeGet(ResultSet Object owner)#nullSafeGet(ResultSet rs, String[] names, SessionImplementor session, Object owner)#g
s#nullSafeGet(ResultSet rs, String[[][]] names, Object owner)#nullSafeGet(ResultSet rs, String[] names, Object owner)#g
s#nullSafeSet(PreparedStatement st, Object value, int index)#nullSafeSet(PreparedStatement st, Object value, int index, SessionImplementor session)#
s#nullSafeSet(PreparedStatement ps, Object value, int index)#nullSafeSet(PreparedStatement ps, Object value, int index, SessionImplementor session)#
s#nullSafeGet(ResultSet rs, String\[\] names, Object owner)#nullSafeGet(ResultSet rs , String[] names, SessionImplementor session , Object owner)#g

############################################
# Hibernate imports and constants
############################################
s#org.hibernate.Hibernate.INTEGER#org.hibernate.type.IntegerType.INSTANCE#
s#org.hibernate.Hibernate.LONG#org.hibernate.type.LongType.INSTANCE#
s#org.hibernate.Hibernate.STRING#org.hibernate.type.StringType.INSTANCE#
s#Hibernate.BIG_DECIMAL#BigDecimalType.INSTANCE#
s#Hibernate.INTEGER#IntegerType.INSTANCE#
s#Hibernate.LONG#LongType.INSTANCE#
s#Hibernate.SHORT#ShortType.INSTANCE#
s#Hibernate.STRING#StringType.INSTANCE#
s#org.hibernate.classic.Session#org.hibernate.Session#g
s#org.hibernate.collection.PersistentCollection#org.hibernate.collection.spi.PersistentCollection#g
s#org.hibernate.collection.PersistentSet#org.hibernate.collection.internal.PersistentSet##g
s#org.hibernate.engine.SessionFactoryImplementor#org.hibernate.engine.spi.SessionFactoryImplementor#g
s#org.hibernate.engine.SessionImplementor#org.hibernate.engine.spi.SessionImplementor#
s#org.jboss.naming.NonSerializableFactory#org.jboss.util.naming.NonSerializableFactory#

# these two go together
s#Environment.CACHE_PROVIDER#Environment.CACHE_PROVIDER_CONFIG#
s#Environment.CACHE_PROVIDER_CONFIG_CONFIG#Environment.CACHE_PROVIDER_CONFIG#

############################################
## Spring Configuration
############################################
s#org.hibernate.cache.NoCacheProvider#org.hibernate.cache.internal.NoCachingRegionFactory#
s#org.springframework.orm.hibernate3.HibernateTransactionManager#org.springframework.orm.hibernate4.HibernateTransactionManager#
s#org.springframework.orm.hibernate3.LocalSessionFactoryBean#org.springframework.orm.hibernate4.LocalSessionFactoryBean#

# these two go together
s#org.springframework.orm.hibernate3.annotation.AnnotationSessionFactoryBean#org.springframework.orm.hibernate4.LocalSessionFactoryBean#
s#AnnotationSessionFactoryBean#LocalSessionFactoryBean#g

